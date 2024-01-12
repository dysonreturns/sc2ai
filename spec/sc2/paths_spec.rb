# frozen_string_literal: true

require "fakefs/spec_helpers"

RSpec.describe Sc2::Paths do
  include FakeFS::SpecHelpers

  before do
    @env_sc2path = ENV.fetch("SC2PATH", nil)
    @env_sc2pf = ENV.fetch("SC2PF", nil)
    @env_is_wsl = ENV.fetch("IS_WSL", nil)
    @env_wsl_distro_name = ENV.fetch("WSL_DISTRO_NAME", nil)
    @env_wsl_interop = ENV.fetch("WSL_INTEROP", nil)

    ENV["SC2PATH"] = nil
    ENV["SC2PF"] = nil
    ENV["IS_WSL"] = nil
    ENV["WSL_DISTRO_NAME"] = nil
    ENV["WSL_DISTRO_NAME"] = nil
    ENV["WSL_INTEROP"] = nil
  end

  after do
    ENV["SC2PATH"] = @env_sc2path
    ENV["SC2PF"] = @env_sc2pf
    ENV["IS_WSL"] = @env_is_wsl
    ENV["WSL_DISTRO_NAME"] = @env_wsl_distro_name
    ENV["WSL_INTEROP"] = @env_wsl_interop
  end

  context "when running on any platform" do
    before do
      ENV["SC2PF"] = "WineLinux"
      ENV["SC2PATH"] = "/a/path"
    end

    it "detects version_dir" do
      expect(described_class.send(:version_dir)).to eq("/a/path/Versions")
    end

    it "detects replay_dir" do
      expect(described_class.replay_dir).to eq("/a/path/Replays")
    end

    it "detects maps_dir" do
      maps_dir = "/a/path/Maps"
      allow(FileTest).to receive(:exist?).with(maps_dir).and_return(true)
      expect(described_class.maps_dir).to eq(maps_dir)
    end

    it "detects maps_dir lowercase alternative" do
      maps_dir_not_exists = "/a/path/Maps"
      maps_dir = "/a/path/maps"
      allow(FileTest).to receive(:exist?).with(maps_dir_not_exists).and_return(false)
      allow(FileTest).to receive(:exist?).with(maps_dir).and_return(true)
      expect(described_class.maps_dir).to eq(maps_dir)
    end

    context "when detecting the executable" do
      let(:builds) { [88_500, 75_689] }
      let(:binary) { Sc2::Paths::BIN_PATH[described_class.platform] }
      let(:version_dir) { Pathname(described_class.install_dir).join("Versions") }

      before do
        ENV["SC2PATH"] = "/a/path"
        FakeFS do
          builds.each do |build|
            version_dir.join("Base#{build}/#{binary}").mkpath
          end
        end
      end

      it "gets latest executable when no build is specified" do
        expect(described_class.executable).to eq("#{version_dir}/Base#{builds.max}/#{binary}")
      end

      it "gets executable for build" do
        build = 75_689
        expect(described_class.executable(base_build: build)).to eq("#{version_dir}/Base#{build}/#{binary}")
      end
    end

    it "finds project_root_dir" do
      project_root_dir = "/root"
      allow(Bundler).to receive(:root).and_return(Pathname(project_root_dir))
      expect(described_class.project_root_dir).to eq(project_root_dir)
    end
  end

  # WineLinux
  context "when manually configuring platform" do
    before do
      ENV["SC2PF"] = "WineLinux"
      ENV["SC2PATH"] = "/a/path"
    end

    it "detects platform from env SC2PF" do
      expect(described_class.platform).to eq(Sc2::Paths::PF_WINE)
    end

    it "detects install_dir from env SC2PATH" do
      expect(described_class.install_dir).to eq("/a/path")
    end
  end

  # Darwin
  context "when running macOS" do
    before do
      allow(Gem::Platform.local).to receive(:os).and_return("darwin")
    end

    it "detects Darwin as platform" do
      expect(described_class.platform).to eq(Sc2::Paths::PF_DARWIN)
    end

    it "detects install_dir from ExecuteInfo.txt" do
      exec_info_contents = "executable = /Applications/StarCraft II/Versions/Base75689/SC2.app/Contents/MacOS/SC2"
      allow(File).to receive(:read).and_return(exec_info_contents)

      allow(Gem::Platform.local).to receive(:os).and_return("darwin")
      expect(described_class.install_dir).to eq("/Applications/StarCraft II")
    end

    it "detects the working directory as nil" do
      expect(described_class.exec_working_dir).to be_nil
    end
  end

  # Windows
  context "when running Windows" do
    let(:current_platform) { Sc2::Paths::PF_WINDOWS }

    before do
      allow(Gem).to receive(:win_platform?).and_return(true)
      allow(Gem::Platform.local).to receive(:os).and_return("mswin")
    end

    it "detects Windows as platform" do
      expect(described_class.platform).to eq(Sc2::Paths::PF_WINDOWS)
    end

    it "detects install_dir from ExecuteInfo.txt" do
      exec_info_contents = 'executable = C:\Program Files (x86)\StarCraft II\Versions\Base86383\SC2_x64.exe'
      outpath = "C:/Program Files (x86)/StarCraft II"
      allow(File).to receive(:read).and_return(exec_info_contents)
      allow(File).to receive(:exist?).with(outpath).and_return(true)
      expect(described_class.install_dir).to eq(outpath)
    end

    it "detects the working directory" do
      expect(described_class.exec_working_dir).to eq("#{Sc2::Paths::BASE_DIR[current_platform]}/#{Sc2::Paths::WORKING_DIR[current_platform]}")
    end
  end

  # Linux
  context "when running Linux" do
    before do
      allow(Gem::Platform.local).to receive(:os).and_return("linux")
    end

    it "detects Linux as platform" do
      expect(described_class.platform).to eq(Sc2::Paths::PF_LINUX)
    end

    it "detects the working directory as nil" do
      expect(described_class.exec_working_dir).to be_nil
    end
  end

  context "when running WSL" do
    before do
      allow(Gem::Platform.local).to receive(:os).and_return("linux")
    end

    it "detects WSL1 as platform from IS_WSL" do
      ENV["IS_WSL"] = "present"
      expect(described_class.platform).to eq(Sc2::Paths::PF_WSL1)
    end

    it "detects WSL1 as platform from WSL_DISTRO_NAME" do
      ENV["WSL_DISTRO_NAME"] = "present"
      allow(Gem::Platform.local).to receive(:os).and_return("linux")
      expect(described_class.platform).to eq(Sc2::Paths::PF_WSL1)
    end

    it "detects WSL2 as platform from WSL_INTEROP" do
      ENV["WSL_DISTRO_NAME"] = "present"
      ENV["WSL_INTEROP"] = "/a/path"
      allow(Gem::Platform.local).to receive(:os).and_return("linux")
      expect(described_class.platform).to eq(Sc2::Paths::PF_WSL2)
    end

    it "detects install directory from ExecuteInfo.txt" do
      ENV["WSL_DISTRO_NAME"] = "present"
      ENV["WSL_INTEROP"] = "/a/path"

      exec_info_contents = 'executable = C:\Program Files (x86)\StarCraft II\Versions\Base86383\SC2_x64.exe'
      outpath = "/mnt/c/Program Files (x86)/StarCraft II"
      allow(File).to receive(:read).and_return(exec_info_contents)
      allow(File).to receive(:exist?).with(outpath).and_return(true)
      expect(described_class.install_dir).to eq(outpath)
    end

    it "detects WSL1 and WSL2 working directory" do
      allow(described_class).to receive(:platform).and_return(Sc2::Paths::PF_WSL1)
      expect(described_class.exec_working_dir).to eq("#{Sc2::Paths::BASE_DIR[Sc2::Paths::PF_WSL1]}/#{Sc2::Paths::WORKING_DIR[Sc2::Paths::PF_WSL1]}")

      allow(described_class).to receive(:platform).and_return(Sc2::Paths::PF_WSL2)
      expect(described_class.exec_working_dir).to eq("#{Sc2::Paths::BASE_DIR[Sc2::Paths::PF_WSL2]}/#{Sc2::Paths::WORKING_DIR[Sc2::Paths::PF_WSL2]}")
    end
  end
end

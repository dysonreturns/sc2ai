# frozen_string_literal: true

require "fakefs/spec_helpers"

RSpec.describe Sc2::MapFile do
  include FakeFS::SpecHelpers

  before do
    @env_sc2path = ENV.fetch("SC2PATH", nil)
    @env_sc2pf = ENV.fetch("SC2PF", nil)
    FakeFS.activate!(io_mocks: true)
  end

  after do
    ENV["SC2PATH"] = @env_sc2path
    ENV["SC2PF"] = @env_sc2pf
    FakeFS.deactivate!
  end

  context "when initializing" do
    let(:map_filename) { "2000AtmospheresAIE.SC2Map" }
    let(:map_sub_dir_path) { "subfolder/submap.SC2Map" }
    let(:map_absolute_path) { "/a/path/to/exact.SC2Map" }
    let(:maps_dir) { Pathname(Sc2::Paths.maps_dir) }

    before do
      ENV["SC2PF"] = "WineLinux"
      ENV["SC2PATH"] = "/a/path"

      maps_dir.join(map_filename).mkpath
      maps_dir.join(map_sub_dir_path).mkpath
      Pathname(map_absolute_path).dirname.mkpath
      File.write(map_absolute_path, "a")
    end

    it "detects from name without extension" do
      map_name = "2000AtmospheresAIE"
      map = build(:map, name: map_name)
      expect(map.path).to eq(maps_dir.join("#{map_name}#{Sc2::MapFile::EXTENSION}").to_s)
    end

    it "detects from filename" do
      map = build(:map, name: map_filename)
      expect(map.path).to eq(maps_dir.join(map_filename.to_s).to_s)
    end

    it "detects from name in subfolder" do
      map = build(:map, name: "submap")
      # /a/path/Maps/subfolder/submap.SC2Map
      expect(map.path).to eq(maps_dir.join(map_sub_dir_path).to_s)
    end

    it "accepts absolute path" do
      map = build(:map, name: map_absolute_path)
      expect(map.path).to eq(map_absolute_path.to_s)
    end

    it "reads binary data" do
      map = build(:map, name: map_absolute_path)
      expect(map.data).to eq("a")
    end
  end
end

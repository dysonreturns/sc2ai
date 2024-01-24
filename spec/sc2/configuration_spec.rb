# frozen_string_literal: true

require "fakefs/spec_helpers"

RSpec.describe Sc2::Configuration do
  include FakeFS::SpecHelpers

  before do
    FakeFS.activate!(io_mocks: true)
  end

  after do
    FakeFS.deactivate!
  end

  context "when instantiating" do
    let(:config_fake_path) { "/root/sc2ai.yml" }
    let(:configuration) { build(:configuration) }
    let(:dummy_config_attributes) do
      {
        sc2_platform: Sc2::Paths::PF_WINE,
        sc2_path: "/a/path",
        host: "127.0.0.1",
        ports: [5001, 5002],
        display_mode: 1, # -displayMode
        windowwidth: 1024, # -windowwidth
        windowheight: 768, # -windowheight
        windowx: 1, # -windowx
        windowy: 2, # -windowy
        verbose: true, # -verbose
        data_dir: "/a/path/data",
        temp_dir: "/a/path/tmp",
        egl_path: "/a/path/egl.so",
        osmesa_path: "/a/path/osmesa.so",
        enable_feature_layer: false
      }
    end

    before do
      Pathname(config_fake_path).dirname.mkpath
      File.write(config_fake_path, "")

      allow(Bundler).to receive(:root).and_return(Pathname("/root"))
      allow(Dir).to receive(:pwd).and_return(Pathname("/root"))
    end

    it "#config_file_path finds config path" do
      expect(configuration.config_file.to_s).to eq(config_fake_path.to_s)
    end

    it "#initialize sets defaults on boot" do
      config = described_class.new
      expect(config.verbose).to be(false)
      expect(config.host).to eq("0.0.0.0")

      allow_any_instance_of(described_class).to receive(:set_defaults)
      config = described_class.new
      expect(config).to have_received(:set_defaults)
    end

    it "#load_config reads the config file and overwrites attributes" do
      allow(Sc2::Paths).to receive(:install_dir).and_return(dummy_config_attributes[:sc2_path])
      allow(Sc2::Paths).to receive(:platform).and_return(dummy_config_attributes[:sc2_platform])
      config_saver = build(:configuration, **dummy_config_attributes)
      config_saver.save_config
      new_conf = described_class.new
      expect(new_conf.to_yaml).to eq(config_saver.to_yaml)
    end

    it "#save_config will save config" do
      allow(Sc2::Paths).to receive(:install_dir).and_return("/a/path")
      allow(Sc2::Paths).to receive(:platform).and_return(Sc2::Paths::PF_WINE)

      config = build(:configuration, **dummy_config_attributes)
      config.save_config
      yaml = Psych.safe_load(config.config_file.read)
      yaml.each do |key, value|
        expect(dummy_config_attributes[key.to_sym]).to eq(value)
      end
    end
  end
end

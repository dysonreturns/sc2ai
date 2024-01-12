# frozen_string_literal: true

RSpec.describe Sc2::Client do
  context "when initializing" do
    it "defaults launch options" do
      allow_any_instance_of(described_class).to receive(:load_default_launch_options)
      config = described_class.new(host: "0.0.0.0", port: 123)
      expect(config).to have_received(:load_default_launch_options)
    end
  end

  context "when launching" do
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
        osmesa_path: "/a/path/osmesa.so"
      }
    end

    it "#command_string passes all configured options" do
      client = described_class.new(port: 5001,
        version: "4.10",
        sc2_platform: Sc2::Paths::PF_WINE,
        sc2_path: "/a/path",
        base_build: 1000,
        data_version: "DATAVERSION",
        host: "127.0.0.1",
        display_mode: 1, # -displayMode
        windowwidth: 1024, # -windowwidth
        windowheight: 768, # -windowheight
        windowx: 1, # -windowx
        windowy: 2, # -windowy
        verbose: true, # -verbose
        data_dir: "/a/path/data",
        temp_dir: "/a/path/tmp",
        egl_path: "/a/path/egl.so",
        osmesa_path: "/a/path/osmesa.so")

      command_string = client.send(:command_string)

      expect(command_string).to include(" -port #{client.port}")
      expect(command_string).to include(" -listen #{client.host}")
      expect(command_string).to include(" -dataVersion #{client.data_version}")
      expect(command_string).to include(" -verbose")

      expect(command_string).to include(" -displayMode #{client.display_mode}")
      expect(command_string).to include(" -windowwidth #{client.windowwidth}")
      expect(command_string).to include(" -windowheight #{client.windowheight}")
      expect(command_string).to include(" -windowx #{client.windowx}")
      expect(command_string).to include(" -windowy #{client.windowy}")

      expect(command_string).to include(" -dataDir #{client.data_dir}")
      expect(command_string).to include(" -tempDir #{client.temp_dir}")
      expect(command_string).to include(" -eglpath #{client.egl_path}")
      expect(command_string).to include(" -osmesapath #{client.osmesa_path}")
    end
  end

  describe "#use_version" do
    it "reads correct base and data versions" do
      client = described_class.new(host: "0.0.0.0", port: 123)
      allow(client).to receive(:versions_json).and_return([{
        "base-version" => 777,
        "data-hash" => "EXAMPLE-DATA",
        "fixed-hash" => "2B2097DC4AD60A2D1E1F38691A1FF111",
        "label" => "4.10",
        "replay-hash" => "6A60E59031A7DB1B272EE87E51E4C7CD",
        "version" => 75_689
      }])
      client.use_version("4.10")
      expect(client.base_build).to eq(777)
      expect(client.data_version).to eq("EXAMPLE-DATA")
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :configuration, class: "Sc2::Configuration" do
    sc2_platform { nil } # Paths.platform
    sc2_path { nil } # Paths.install_dir

    ports { nil } # [] # -port 1234

    host { nil } # "0.0.0.0" # -listen
    verbose { false } # false # -verbose

    display_mode { nil } # -displayMode
    windowwidth { nil } # -windowwidth
    windowheight { nil } # -windowheight
    windowx { nil } # -windowx
    windowy { nil } # -windowy

    # Linux
    data_dir { nil } # -dataDir '../../'
    temp_dir { nil } # -tempDir '/tmp/'
    egl_path { nil } # -eglpath '/usr/lib/nvidia-384/libEGL.so'
    osmesa_path { nil } # -osmesapath '/usr/lib/x86_64-linux-gnu/libOSMesa.so'
  end
end

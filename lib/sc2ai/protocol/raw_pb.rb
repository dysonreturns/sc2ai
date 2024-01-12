# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: sc2ai/protocol/raw.proto

require 'google/protobuf'

require 'sc2ai/protocol/common_pb'


descriptor_data = "\n\x18sc2ai/protocol/raw.proto\x12\x03\x41pi\x1a\x1bsc2ai/protocol/common.proto\"\xef\x01\n\x08StartRaw\x12\x1e\n\x08map_size\x18\x01 \x01(\x0b\x32\x0c.Api.Size2DI\x12$\n\x0cpathing_grid\x18\x02 \x01(\x0b\x32\x0e.Api.ImageData\x12&\n\x0eterrain_height\x18\x03 \x01(\x0b\x32\x0e.Api.ImageData\x12&\n\x0eplacement_grid\x18\x04 \x01(\x0b\x32\x0e.Api.ImageData\x12&\n\rplayable_area\x18\x05 \x01(\x0b\x32\x0f.Api.RectangleI\x12%\n\x0fstart_locations\x18\x06 \x03(\x0b\x32\x0c.Api.Point2D\"\xc4\x01\n\x0eObservationRaw\x12\x1e\n\x06player\x18\x01 \x01(\x0b\x32\x0e.Api.PlayerRaw\x12\x18\n\x05units\x18\x02 \x03(\x0b\x32\t.Api.Unit\x12 \n\tmap_state\x18\x03 \x01(\x0b\x32\r.Api.MapState\x12\x19\n\x05\x65vent\x18\x04 \x01(\x0b\x32\n.Api.Event\x12\x1c\n\x07\x65\x66\x66\x65\x63ts\x18\x05 \x03(\x0b\x32\x0b.Api.Effect\x12\x1d\n\x05radar\x18\x06 \x03(\x0b\x32\x0e.Api.RadarRing\"4\n\tRadarRing\x12\x17\n\x03pos\x18\x01 \x01(\x0b\x32\n.Api.Point\x12\x0e\n\x06radius\x18\x02 \x01(\x02\"C\n\x0bPowerSource\x12\x17\n\x03pos\x18\x01 \x01(\x0b\x32\n.Api.Point\x12\x0e\n\x06radius\x18\x02 \x01(\x02\x12\x0b\n\x03tag\x18\x03 \x01(\x04\"e\n\tPlayerRaw\x12\'\n\rpower_sources\x18\x01 \x03(\x0b\x32\x10.Api.PowerSource\x12\x1a\n\x06\x63\x61mera\x18\x02 \x01(\x0b\x32\n.Api.Point\x12\x13\n\x0bupgrade_ids\x18\x03 \x03(\r\"\x84\x01\n\tUnitOrder\x12\x12\n\nability_id\x18\x01 \x01(\r\x12,\n\x16target_world_space_pos\x18\x02 \x01(\x0b\x32\n.Api.PointH\x00\x12\x19\n\x0ftarget_unit_tag\x18\x03 \x01(\x04H\x00\x12\x10\n\x08progress\x18\x04 \x01(\x02\x42\x08\n\x06target\"\x9b\x01\n\rPassengerUnit\x12\x0b\n\x03tag\x18\x01 \x01(\x04\x12\x0e\n\x06health\x18\x02 \x01(\x02\x12\x12\n\nhealth_max\x18\x03 \x01(\x02\x12\x0e\n\x06shield\x18\x04 \x01(\x02\x12\x12\n\nshield_max\x18\x07 \x01(\x02\x12\x0e\n\x06\x65nergy\x18\x05 \x01(\x02\x12\x12\n\nenergy_max\x18\x08 \x01(\x02\x12\x11\n\tunit_type\x18\x06 \x01(\r\"5\n\x0bRallyTarget\x12\x19\n\x05point\x18\x01 \x01(\x0b\x32\n.Api.Point\x12\x0b\n\x03tag\x18\x02 \x01(\x04\"\xa8\x08\n\x04Unit\x12&\n\x0c\x64isplay_type\x18\x01 \x01(\x0e\x32\x10.Api.DisplayType\x12\x1f\n\x08\x61lliance\x18\x02 \x01(\x0e\x32\r.Api.Alliance\x12\x0b\n\x03tag\x18\x03 \x01(\x04\x12\x11\n\tunit_type\x18\x04 \x01(\r\x12\r\n\x05owner\x18\x05 \x01(\x05\x12\x17\n\x03pos\x18\x06 \x01(\x0b\x32\n.Api.Point\x12\x0e\n\x06\x66\x61\x63ing\x18\x07 \x01(\x02\x12\x0e\n\x06radius\x18\x08 \x01(\x02\x12\x16\n\x0e\x62uild_progress\x18\t \x01(\x02\x12\x1e\n\x05\x63loak\x18\n \x01(\x0e\x32\x0f.Api.CloakState\x12\x10\n\x08\x62uff_ids\x18\x1b \x03(\r\x12\x14\n\x0c\x64\x65tect_range\x18\x1f \x01(\x02\x12\x13\n\x0bradar_range\x18  \x01(\x02\x12\x13\n\x0bis_selected\x18\x0b \x01(\x08\x12\x14\n\x0cis_on_screen\x18\x0c \x01(\x08\x12\x0f\n\x07is_blip\x18\r \x01(\x08\x12\x12\n\nis_powered\x18# \x01(\x08\x12\x11\n\tis_active\x18\' \x01(\x08\x12\x1c\n\x14\x61ttack_upgrade_level\x18( \x01(\x05\x12\x1b\n\x13\x61rmor_upgrade_level\x18) \x01(\x05\x12\x1c\n\x14shield_upgrade_level\x18* \x01(\x05\x12\x0e\n\x06health\x18\x0e \x01(\x02\x12\x12\n\nhealth_max\x18\x0f \x01(\x02\x12\x0e\n\x06shield\x18\x10 \x01(\x02\x12\x12\n\nshield_max\x18$ \x01(\x02\x12\x0e\n\x06\x65nergy\x18\x11 \x01(\x02\x12\x12\n\nenergy_max\x18% \x01(\x02\x12\x18\n\x10mineral_contents\x18\x12 \x01(\x05\x12\x18\n\x10vespene_contents\x18\x13 \x01(\x05\x12\x11\n\tis_flying\x18\x14 \x01(\x08\x12\x13\n\x0bis_burrowed\x18\x15 \x01(\x08\x12\x18\n\x10is_hallucination\x18& \x01(\x08\x12\x1e\n\x06orders\x18\x16 \x03(\x0b\x32\x0e.Api.UnitOrder\x12\x12\n\nadd_on_tag\x18\x17 \x01(\x04\x12&\n\npassengers\x18\x18 \x03(\x0b\x32\x12.Api.PassengerUnit\x12\x19\n\x11\x63\x61rgo_space_taken\x18\x19 \x01(\x05\x12\x17\n\x0f\x63\x61rgo_space_max\x18\x1a \x01(\x05\x12\x1b\n\x13\x61ssigned_harvesters\x18\x1c \x01(\x05\x12\x18\n\x10ideal_harvesters\x18\x1d \x01(\x05\x12\x17\n\x0fweapon_cooldown\x18\x1e \x01(\x02\x12\x1a\n\x12\x65ngaged_target_tag\x18\" \x01(\x04\x12\x1c\n\x14\x62uff_duration_remain\x18+ \x01(\x05\x12\x19\n\x11\x62uff_duration_max\x18, \x01(\x05\x12\'\n\rrally_targets\x18- \x03(\x0b\x32\x10.Api.RallyTarget\"M\n\x08MapState\x12\"\n\nvisibility\x18\x01 \x01(\x0b\x32\x0e.Api.ImageData\x12\x1d\n\x05\x63reep\x18\x02 \x01(\x0b\x32\x0e.Api.ImageData\"\x1b\n\x05\x45vent\x12\x12\n\ndead_units\x18\x01 \x03(\x04\"v\n\x06\x45\x66\x66\x65\x63t\x12\x11\n\teffect_id\x18\x01 \x01(\r\x12\x19\n\x03pos\x18\x02 \x03(\x0b\x32\x0c.Api.Point2D\x12\x1f\n\x08\x61lliance\x18\x03 \x01(\x0e\x32\r.Api.Alliance\x12\r\n\x05owner\x18\x04 \x01(\x05\x12\x0e\n\x06radius\x18\x05 \x01(\x02\"\xb2\x01\n\tActionRaw\x12\x31\n\x0cunit_command\x18\x01 \x01(\x0b\x32\x19.Api.ActionRawUnitCommandH\x00\x12/\n\x0b\x63\x61mera_move\x18\x02 \x01(\x0b\x32\x18.Api.ActionRawCameraMoveH\x00\x12\x37\n\x0ftoggle_autocast\x18\x03 \x01(\x0b\x32\x1c.Api.ActionRawToggleAutocastH\x00\x42\x08\n\x06\x61\x63tion\"\xa9\x01\n\x14\x41\x63tionRawUnitCommand\x12\x12\n\nability_id\x18\x01 \x01(\x05\x12.\n\x16target_world_space_pos\x18\x02 \x01(\x0b\x32\x0c.Api.Point2DH\x00\x12\x19\n\x0ftarget_unit_tag\x18\x03 \x01(\x04H\x00\x12\x11\n\tunit_tags\x18\x04 \x03(\x04\x12\x15\n\rqueue_command\x18\x05 \x01(\x08\x42\x08\n\x06target\"=\n\x13\x41\x63tionRawCameraMove\x12&\n\x12\x63\x65nter_world_space\x18\x01 \x01(\x0b\x32\n.Api.Point\"@\n\x17\x41\x63tionRawToggleAutocast\x12\x12\n\nability_id\x18\x01 \x01(\x05\x12\x11\n\tunit_tags\x18\x02 \x03(\x04*E\n\x0b\x44isplayType\x12\x0b\n\x07Visible\x10\x01\x12\x0c\n\x08Snapshot\x10\x02\x12\n\n\x06Hidden\x10\x03\x12\x0f\n\x0bPlaceholder\x10\x04*6\n\x08\x41lliance\x12\x08\n\x04Self\x10\x01\x12\x08\n\x04\x41lly\x10\x02\x12\x0b\n\x07Neutral\x10\x03\x12\t\n\x05\x45nemy\x10\x04*e\n\nCloakState\x12\x12\n\x0e\x43loakedUnknown\x10\x00\x12\x0b\n\x07\x43loaked\x10\x01\x12\x13\n\x0f\x43loakedDetected\x10\x02\x12\x0e\n\nNotCloaked\x10\x03\x12\x11\n\rCloakedAllied\x10\x04"

pool = Google::Protobuf::DescriptorPool.generated_pool

begin
  pool.add_serialized_file(descriptor_data)
rescue TypeError
  # Compatibility code: will be removed in the next major version.
  require 'google/protobuf/descriptor_pb'
  parsed = Google::Protobuf::FileDescriptorProto.decode(descriptor_data)
  parsed.clear_dependency
  serialized = parsed.class.encode(parsed)
  file = pool.add_serialized_file(serialized)
  warn "Warning: Protobuf detected an import path issue while loading generated file #{__FILE__}"
  imports = [
    ["Api.Size2DI", "sc2ai/protocol/common.proto"],
  ]
  imports.each do |type_name, expected_filename|
    import_file = pool.lookup(type_name).file_descriptor
    if import_file.name != expected_filename
      warn "- #{file.name} imports #{expected_filename}, but that import was loaded as #{import_file.name}"
    end
  end
  warn "Each proto file must use a consistent fully-qualified name."
  warn "This will become an error in the next major version."
end

module Api
  StartRaw = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.StartRaw").msgclass
  ObservationRaw = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ObservationRaw").msgclass
  RadarRing = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.RadarRing").msgclass
  PowerSource = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.PowerSource").msgclass
  PlayerRaw = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.PlayerRaw").msgclass
  UnitOrder = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.UnitOrder").msgclass
  PassengerUnit = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.PassengerUnit").msgclass
  RallyTarget = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.RallyTarget").msgclass
  Unit = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.Unit").msgclass
  MapState = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.MapState").msgclass
  Event = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.Event").msgclass
  Effect = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.Effect").msgclass
  ActionRaw = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionRaw").msgclass
  ActionRawUnitCommand = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionRawUnitCommand").msgclass
  ActionRawCameraMove = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionRawCameraMove").msgclass
  ActionRawToggleAutocast = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionRawToggleAutocast").msgclass
  DisplayType = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.DisplayType").enummodule
  Alliance = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.Alliance").enummodule
  CloakState = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.CloakState").enummodule
end
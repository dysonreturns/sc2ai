# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: sc2ai/protocol/data.proto

require 'google/protobuf'

require 'sc2ai/protocol/common_pb'


descriptor_data = "\n\x19sc2ai/protocol/data.proto\x12\x03\x41pi\x1a\x1bsc2ai/protocol/common.proto\"\xb9\x03\n\x0b\x41\x62ilityData\x12\x12\n\nability_id\x18\x01 \x01(\r\x12\x11\n\tlink_name\x18\x02 \x01(\t\x12\x12\n\nlink_index\x18\x03 \x01(\r\x12\x13\n\x0b\x62utton_name\x18\x04 \x01(\t\x12\x15\n\rfriendly_name\x18\x05 \x01(\t\x12\x0e\n\x06hotkey\x18\x06 \x01(\t\x12\x1c\n\x14remaps_to_ability_id\x18\x07 \x01(\r\x12\x11\n\tavailable\x18\x08 \x01(\x08\x12\'\n\x06target\x18\t \x01(\x0e\x32\x17.Api.AbilityData.Target\x12\x15\n\rallow_minimap\x18\n \x01(\x08\x12\x16\n\x0e\x61llow_autocast\x18\x0b \x01(\x08\x12\x13\n\x0bis_building\x18\x0c \x01(\x08\x12\x18\n\x10\x66ootprint_radius\x18\r \x01(\x02\x12\x1c\n\x14is_instant_placement\x18\x0e \x01(\x08\x12\x12\n\ncast_range\x18\x0f \x01(\x02\"I\n\x06Target\x12\x08\n\x04None\x10\x01\x12\t\n\x05Point\x10\x02\x12\x08\n\x04Unit\x10\x03\x12\x0f\n\x0bPointOrUnit\x10\x04\x12\x0f\n\x0bPointOrNone\x10\x05\"?\n\x0b\x44\x61mageBonus\x12!\n\tattribute\x18\x01 \x01(\x0e\x32\x0e.Api.Attribute\x12\r\n\x05\x62onus\x18\x02 \x01(\x02\"\xc1\x01\n\x06Weapon\x12$\n\x04type\x18\x01 \x01(\x0e\x32\x16.Api.Weapon.TargetType\x12\x0e\n\x06\x64\x61mage\x18\x02 \x01(\x02\x12&\n\x0c\x64\x61mage_bonus\x18\x03 \x03(\x0b\x32\x10.Api.DamageBonus\x12\x0f\n\x07\x61ttacks\x18\x04 \x01(\r\x12\r\n\x05range\x18\x05 \x01(\x02\x12\r\n\x05speed\x18\x06 \x01(\x02\"*\n\nTargetType\x12\n\n\x06Ground\x10\x01\x12\x07\n\x03\x41ir\x10\x02\x12\x07\n\x03\x41ny\x10\x03\"\xf4\x03\n\x0cUnitTypeData\x12\x0f\n\x07unit_id\x18\x01 \x01(\r\x12\x0c\n\x04name\x18\x02 \x01(\t\x12\x11\n\tavailable\x18\x03 \x01(\x08\x12\x12\n\ncargo_size\x18\x04 \x01(\r\x12\x14\n\x0cmineral_cost\x18\x0c \x01(\r\x12\x14\n\x0cvespene_cost\x18\r \x01(\r\x12\x15\n\rfood_required\x18\x0e \x01(\x02\x12\x15\n\rfood_provided\x18\x12 \x01(\x02\x12\x12\n\nability_id\x18\x0f \x01(\r\x12\x17\n\x04race\x18\x10 \x01(\x0e\x32\t.Api.Race\x12\x12\n\nbuild_time\x18\x11 \x01(\x02\x12\x13\n\x0bhas_vespene\x18\x13 \x01(\x08\x12\x14\n\x0chas_minerals\x18\x14 \x01(\x08\x12\x13\n\x0bsight_range\x18\x19 \x01(\x02\x12\x12\n\ntech_alias\x18\x15 \x03(\r\x12\x12\n\nunit_alias\x18\x16 \x01(\r\x12\x18\n\x10tech_requirement\x18\x17 \x01(\r\x12\x18\n\x10require_attached\x18\x18 \x01(\x08\x12\"\n\nattributes\x18\x08 \x03(\x0e\x32\x0e.Api.Attribute\x12\x16\n\x0emovement_speed\x18\t \x01(\x02\x12\r\n\x05\x61rmor\x18\n \x01(\x02\x12\x1c\n\x07weapons\x18\x0b \x03(\x0b\x32\x0b.Api.Weapon\"\x86\x01\n\x0bUpgradeData\x12\x12\n\nupgrade_id\x18\x01 \x01(\r\x12\x0c\n\x04name\x18\x02 \x01(\t\x12\x14\n\x0cmineral_cost\x18\x03 \x01(\r\x12\x14\n\x0cvespene_cost\x18\x04 \x01(\r\x12\x15\n\rresearch_time\x18\x05 \x01(\x02\x12\x12\n\nability_id\x18\x06 \x01(\r\")\n\x08\x42uffData\x12\x0f\n\x07\x62uff_id\x18\x01 \x01(\r\x12\x0c\n\x04name\x18\x02 \x01(\t\"T\n\nEffectData\x12\x11\n\teffect_id\x18\x01 \x01(\r\x12\x0c\n\x04name\x18\x02 \x01(\t\x12\x15\n\rfriendly_name\x18\x03 \x01(\t\x12\x0e\n\x06radius\x18\x04 \x01(\x02*\x9e\x01\n\tAttribute\x12\t\n\x05Light\x10\x01\x12\x0b\n\x07\x41rmored\x10\x02\x12\x0e\n\nBiological\x10\x03\x12\x0e\n\nMechanical\x10\x04\x12\x0b\n\x07Robotic\x10\x05\x12\x0b\n\x07Psionic\x10\x06\x12\x0b\n\x07Massive\x10\x07\x12\r\n\tStructure\x10\x08\x12\t\n\x05Hover\x10\t\x12\n\n\x06Heroic\x10\n\x12\x0c\n\x08Summoned\x10\x0b"

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
  AbilityData = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.AbilityData").msgclass
  AbilityData::Target = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.AbilityData.Target").enummodule
  DamageBonus = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.DamageBonus").msgclass
  Weapon = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.Weapon").msgclass
  Weapon::TargetType = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.Weapon.TargetType").enummodule
  UnitTypeData = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.UnitTypeData").msgclass
  UpgradeData = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.UpgradeData").msgclass
  BuffData = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.BuffData").msgclass
  EffectData = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.EffectData").msgclass
  Attribute = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.Attribute").enummodule
end

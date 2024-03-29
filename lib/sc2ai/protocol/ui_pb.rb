# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: sc2ai/protocol/ui.proto

require 'google/protobuf'


descriptor_data = "\n\x17sc2ai/protocol/ui.proto\x12\x03\x41pi\"\xcf\x01\n\rObservationUI\x12!\n\x06groups\x18\x01 \x03(\x0b\x32\x11.Api.ControlGroup\x12\"\n\x06single\x18\x02 \x01(\x0b\x32\x10.Api.SinglePanelH\x00\x12 \n\x05multi\x18\x03 \x01(\x0b\x32\x0f.Api.MultiPanelH\x00\x12 \n\x05\x63\x61rgo\x18\x04 \x01(\x0b\x32\x0f.Api.CargoPanelH\x00\x12*\n\nproduction\x18\x05 \x01(\x0b\x32\x14.Api.ProductionPanelH\x00\x42\x07\n\x05panel\"T\n\x0c\x43ontrolGroup\x12\x1b\n\x13\x63ontrol_group_index\x18\x01 \x01(\r\x12\x18\n\x10leader_unit_type\x18\x02 \x01(\r\x12\r\n\x05\x63ount\x18\x03 \x01(\r\"\xfa\x01\n\x08UnitInfo\x12\x11\n\tunit_type\x18\x01 \x01(\r\x12\x17\n\x0fplayer_relative\x18\x02 \x01(\r\x12\x0e\n\x06health\x18\x03 \x01(\x05\x12\x0f\n\x07shields\x18\x04 \x01(\x05\x12\x0e\n\x06\x65nergy\x18\x05 \x01(\x05\x12\x1d\n\x15transport_slots_taken\x18\x06 \x01(\x05\x12\x16\n\x0e\x62uild_progress\x18\x07 \x01(\x02\x12\x1d\n\x06\x61\x64\x64_on\x18\x08 \x01(\x0b\x32\r.Api.UnitInfo\x12\x12\n\nmax_health\x18\t \x01(\x05\x12\x13\n\x0bmax_shields\x18\n \x01(\x05\x12\x12\n\nmax_energy\x18\x0b \x01(\x05\"\x92\x01\n\x0bSinglePanel\x12\x1b\n\x04unit\x18\x01 \x01(\x0b\x32\r.Api.UnitInfo\x12\x1c\n\x14\x61ttack_upgrade_level\x18\x02 \x01(\x05\x12\x1b\n\x13\x61rmor_upgrade_level\x18\x03 \x01(\x05\x12\x1c\n\x14shield_upgrade_level\x18\x04 \x01(\x05\x12\r\n\x05\x62uffs\x18\x05 \x03(\x05\"*\n\nMultiPanel\x12\x1c\n\x05units\x18\x01 \x03(\x0b\x32\r.Api.UnitInfo\"e\n\nCargoPanel\x12\x1b\n\x04unit\x18\x01 \x01(\x0b\x32\r.Api.UnitInfo\x12!\n\npassengers\x18\x02 \x03(\x0b\x32\r.Api.UnitInfo\x12\x17\n\x0fslots_available\x18\x03 \x01(\x05\"7\n\tBuildItem\x12\x12\n\nability_id\x18\x01 \x01(\r\x12\x16\n\x0e\x62uild_progress\x18\x02 \x01(\x02\"|\n\x0fProductionPanel\x12\x1b\n\x04unit\x18\x01 \x01(\x0b\x32\r.Api.UnitInfo\x12\"\n\x0b\x62uild_queue\x18\x02 \x03(\x0b\x32\r.Api.UnitInfo\x12(\n\x10production_queue\x18\x03 \x03(\x0b\x32\x0e.Api.BuildItem\"\xf7\x03\n\x08\x41\x63tionUI\x12\x30\n\rcontrol_group\x18\x01 \x01(\x0b\x32\x17.Api.ActionControlGroupH\x00\x12,\n\x0bselect_army\x18\x02 \x01(\x0b\x32\x15.Api.ActionSelectArmyH\x00\x12\x37\n\x11select_warp_gates\x18\x03 \x01(\x0b\x32\x1a.Api.ActionSelectWarpGatesH\x00\x12.\n\x0cselect_larva\x18\x04 \x01(\x0b\x32\x16.Api.ActionSelectLarvaH\x00\x12\x39\n\x12select_idle_worker\x18\x05 \x01(\x0b\x32\x1b.Api.ActionSelectIdleWorkerH\x00\x12,\n\x0bmulti_panel\x18\x06 \x01(\x0b\x32\x15.Api.ActionMultiPanelH\x00\x12\x32\n\x0b\x63\x61rgo_panel\x18\x07 \x01(\x0b\x32\x1b.Api.ActionCargoPanelUnloadH\x00\x12\x45\n\x10production_panel\x18\x08 \x01(\x0b\x32).Api.ActionProductionPanelRemoveFromQueueH\x00\x12\x34\n\x0ftoggle_autocast\x18\t \x01(\x0b\x32\x19.Api.ActionToggleAutocastH\x00\x42\x08\n\x06\x61\x63tion\"\xc9\x01\n\x12\x41\x63tionControlGroup\x12:\n\x06\x61\x63tion\x18\x01 \x01(\x0e\x32*.Api.ActionControlGroup.ControlGroupAction\x12\x1b\n\x13\x63ontrol_group_index\x18\x02 \x01(\r\"Z\n\x12\x43ontrolGroupAction\x12\n\n\x06Recall\x10\x01\x12\x07\n\x03Set\x10\x02\x12\n\n\x06\x41ppend\x10\x03\x12\x0f\n\x0bSetAndSteal\x10\x04\x12\x12\n\x0e\x41ppendAndSteal\x10\x05\")\n\x10\x41\x63tionSelectArmy\x12\x15\n\rselection_add\x18\x01 \x01(\x08\".\n\x15\x41\x63tionSelectWarpGates\x12\x15\n\rselection_add\x18\x01 \x01(\x08\"\x13\n\x11\x41\x63tionSelectLarva\"w\n\x16\x41\x63tionSelectIdleWorker\x12.\n\x04type\x18\x01 \x01(\x0e\x32 .Api.ActionSelectIdleWorker.Type\"-\n\x04Type\x12\x07\n\x03Set\x10\x01\x12\x07\n\x03\x41\x64\x64\x10\x02\x12\x07\n\x03\x41ll\x10\x03\x12\n\n\x06\x41\x64\x64\x41ll\x10\x04\"\xa8\x01\n\x10\x41\x63tionMultiPanel\x12(\n\x04type\x18\x01 \x01(\x0e\x32\x1a.Api.ActionMultiPanel.Type\x12\x12\n\nunit_index\x18\x02 \x01(\x05\"V\n\x04Type\x12\x10\n\x0cSingleSelect\x10\x01\x12\x10\n\x0c\x44\x65selectUnit\x10\x02\x12\x13\n\x0fSelectAllOfType\x10\x03\x12\x15\n\x11\x44\x65selectAllOfType\x10\x04\",\n\x16\x41\x63tionCargoPanelUnload\x12\x12\n\nunit_index\x18\x01 \x01(\x05\":\n$ActionProductionPanelRemoveFromQueue\x12\x12\n\nunit_index\x18\x01 \x01(\x05\"*\n\x14\x41\x63tionToggleAutocast\x12\x12\n\nability_id\x18\x01 \x01(\x05"

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
  ObservationUI = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ObservationUI").msgclass
  ControlGroup = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ControlGroup").msgclass
  UnitInfo = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.UnitInfo").msgclass
  SinglePanel = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.SinglePanel").msgclass
  MultiPanel = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.MultiPanel").msgclass
  CargoPanel = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.CargoPanel").msgclass
  BuildItem = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.BuildItem").msgclass
  ProductionPanel = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ProductionPanel").msgclass
  ActionUI = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionUI").msgclass
  ActionControlGroup = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionControlGroup").msgclass
  ActionControlGroup::ControlGroupAction = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionControlGroup.ControlGroupAction").enummodule
  ActionSelectArmy = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionSelectArmy").msgclass
  ActionSelectWarpGates = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionSelectWarpGates").msgclass
  ActionSelectLarva = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionSelectLarva").msgclass
  ActionSelectIdleWorker = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionSelectIdleWorker").msgclass
  ActionSelectIdleWorker::Type = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionSelectIdleWorker.Type").enummodule
  ActionMultiPanel = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionMultiPanel").msgclass
  ActionMultiPanel::Type = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionMultiPanel.Type").enummodule
  ActionCargoPanelUnload = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionCargoPanelUnload").msgclass
  ActionProductionPanelRemoveFromQueue = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionProductionPanelRemoveFromQueue").msgclass
  ActionToggleAutocast = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ActionToggleAutocast").msgclass
end

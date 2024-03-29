# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: sc2ai/protocol/common.proto

require 'google/protobuf'


descriptor_data = "\n\x1bsc2ai/protocol/common.proto\x12\x03\x41pi\">\n\x10\x41vailableAbility\x12\x12\n\nability_id\x18\x01 \x01(\x05\x12\x16\n\x0erequires_point\x18\x02 \x01(\x08\"M\n\tImageData\x12\x16\n\x0e\x62its_per_pixel\x18\x01 \x01(\x05\x12\x1a\n\x04size\x18\x02 \x01(\x0b\x32\x0c.Api.Size2DI\x12\x0c\n\x04\x64\x61ta\x18\x03 \x01(\x0c\"\x1e\n\x06PointI\x12\t\n\x01x\x18\x01 \x01(\x05\x12\t\n\x01y\x18\x02 \x01(\x05\">\n\nRectangleI\x12\x17\n\x02p0\x18\x01 \x01(\x0b\x32\x0b.Api.PointI\x12\x17\n\x02p1\x18\x02 \x01(\x0b\x32\x0b.Api.PointI\"\x1f\n\x07Point2D\x12\t\n\x01x\x18\x01 \x01(\x02\x12\t\n\x01y\x18\x02 \x01(\x02\"(\n\x05Point\x12\t\n\x01x\x18\x01 \x01(\x02\x12\t\n\x01y\x18\x02 \x01(\x02\x12\t\n\x01z\x18\x03 \x01(\x02\"\x1f\n\x07Size2DI\x12\t\n\x01x\x18\x01 \x01(\x05\x12\t\n\x01y\x18\x02 \x01(\x05*A\n\x04Race\x12\n\n\x06NoRace\x10\x00\x12\n\n\x06Terran\x10\x01\x12\x08\n\x04Zerg\x10\x02\x12\x0b\n\x07Protoss\x10\x03\x12\n\n\x06Random\x10\x04"

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
  AvailableAbility = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.AvailableAbility").msgclass
  ImageData = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.ImageData").msgclass
  PointI = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.PointI").msgclass
  RectangleI = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.RectangleI").msgclass
  Point2D = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.Point2D").msgclass
  Point = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.Point").msgclass
  Size2DI = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.Size2DI").msgclass
  Race = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("Api.Race").enummodule
end

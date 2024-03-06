desc "Generates sig/ files. This should remain outside :default task"
task :gensig do
  # REMOVED: Removed because protobuf does not match google-protobuf.
  #    ... once RBS_PROTOBUF_BACKEND=google-protobuf is supported, bring this back in
  # Requires google protobuf to be installed (uses protoc executable)
  # sh "RBS_PROTOBUF_BACKEND=protobuf protoc --proto_path=data/ --rbs_out=sig/protos data/sc2ai/protocol/*.proto"

  # REMOVED: This is the ruby way, but the CLI is more trustworthy long-term, so executing "sord" below
  # Build gem sig
  # require "sord"
  # plugin = Sord::ParlourPlugin.new(rbs: true, tags:[])
  # plugin.parlour = Parlour::RbsGenerator.new
  # plugin.generate(plugin.parlour.root)
  # File.write("./sig/sc2ai.rbs", plugin.parlour.rbs)
  # puts "Done. written to sig/sc2ai.rbs and sig/protos/*"

  sh "bundle exec sord sig/sc2ai.rbs"
end

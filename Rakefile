require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc "Compile protobuf files"
task :protoc do
  sh "protoc --ruby_out=spec/proto -Ispec/proto spec/proto/*.proto"
end

task :spec => :protoc unless ENV["CI"]

task :default => :spec

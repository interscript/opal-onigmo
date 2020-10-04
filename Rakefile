require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "opal/rspec/rake_task"

RSpec::Core::RakeTask.new(:spec)

Opal::RSpec::RakeTask.new("spec-opal") do |server, task|
  require 'opal/onigmo'
end

task :generate do
  sh 'cd Onigmo; sh ./build-wasm.sh; mv onigmo.wasm ../opal/onigmo/onigmo.wasm'
  sh 'erb opal/onigmo/constants.rb.erb > opal/onigmo/constants.rb'
end

task :default => [:spec, "spec-opal"]

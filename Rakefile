require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :generate do
  sh 'erb opal/onigmo/constants.rb.erb > opal/onigmo/constants.rb'
end

task :default => :spec

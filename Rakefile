require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "opal/rspec/rake_task"
require 'erb'

RSpec::Core::RakeTask.new(:spec)

Opal::RSpec::RakeTask.new("spec-opal") do |server, task|
  require 'opal/onigmo'
end

task :generate => ['opal/onigmo/constants.rb', 'opal/onigmo/onigmo.wasm'] do
end

def render_template(template, output, vars)
  tmpl = File.read(template)
  erb = ERB.new(tmpl, 0, "<>")
  File.open(output, "w") do |f|
    f.puts erb.result_with_hash(vars)
  end
end

file 'opal/onigmo/constants.rb' => ['opal/onigmo/constants.rb.erb', 'Onigmo/onigmo.h'] do |task|
  render_template(
    File.expand_path(task.prerequisites.first, __dir__),
    task.name,
    {onigmo_h: File.read('Onigmo/onigmo.h')}
  )
end

file 'opal/onigmo/onigmo.wasm' => ['Onigmo/build-wasm.sh'] do |task|
  sh "cd Onigmo; sh ./build-wasm.sh; mv onigmo.wasm #{task.name}"
end

task :default => [:spec, "spec-opal"]

require 'chake'

task :test do
  sh './test/run_all'
end

task :default => :test

file 'ssh_config.erb'
file '.ssh_config' => ['nodes.yaml', 'ssh_config.erb'] do |t|
  require 'erb'
  template = ERB.new(File.read('ssh_config.erb'))
  File.open(t.name, 'w') do |f|
    f.write(template.result(binding))
  end
  puts 'ERB %s' % t.name
end

task :bootstrap_common => '.ssh_config'

# dependencies
task 'bootstrap:integration' => 'converge:database'

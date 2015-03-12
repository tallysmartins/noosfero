$SPB_ENV = ENV.fetch('SPB_ENV', 'development')

ssh_config_file = "config/#{$SPB_ENV}/ssh_config"
ips_file = "config/#{$SPB_ENV}/ips.yaml"
config_file = "config/#{$SPB_ENV}/config.yaml"

ENV['CHAKE_SSH_CONFIG'] = ssh_config_file

require 'chake'

if Chake::VERSION < '0.4'
  fail "Please upgrade to chake 0.4+"
end

config = YAML.load_file(config_file)
ips = YAML.load_file(ips_file)
$nodes.each do |node|
  node.data['config'] = config
  node.data['peers'] = ips
end

task :console do
  require 'pry'
  binding.pry
end

task :test do
  sh './test/run_all'
end

task :default => :test

file 'ssh_config.erb'
file 'config/development/ssh_config' => ['nodes.yaml', 'config/development/ips.yaml', 'ssh_config.erb'] do |t|
  require 'erb'
  template = ERB.new(File.read('ssh_config.erb'))
  File.open(t.name, 'w') do |f|
    f.write(template.result(binding))
  end
  puts 'ERB %s' % t.name
end

task :bootstrap_common => 'config/development/ssh_config'

unless ENV['nodeps']
  task 'converge:integration' => 'converge:database'
  task 'converge:social'      => 'converge:database'
end

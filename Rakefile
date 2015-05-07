begin
  load 'local.rake'
rescue LoadError
  # nothing
end

$SPB_ENV = ENV.fetch('SPB_ENV', 'local')

ssh_config_file = "config/#{$SPB_ENV}/ssh_config"
ips_file = "config/#{$SPB_ENV}/ips.yaml"
config_file = "config/#{$SPB_ENV}/config.yaml"

ENV['CHAKE_SSH_CONFIG'] = ssh_config_file

require 'chake'

if Chake::VERSION < '0.4.3'
  fail "Please upgrade to chake 0.4.3+"
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
  sh "SPB_ENV=#{$SPB_ENV} ./test/run_all"
end

file 'ssh_config.erb'
file 'config/local/ssh_config' => ['nodes.yaml', 'config/local/ips.yaml', 'ssh_config.erb', 'Rakefile'] do |t|
  require 'erb'
  template = ERB.new(File.read('ssh_config.erb'))
  File.open(t.name, 'w') do |f|
    f.write(template.result(binding))
  end
  puts 'ERB %s' % t.name
end

task :bootstrap_common => 'config/local/ssh_config'

unless ENV['nodeps']
  task 'converge:integration' => 'converge:database'
  task 'converge:social'      => 'converge:database'
end

$ALT_SSH_PORT = config.fetch('alt_ssh_port', 2222)

$nodes.find { |n| n.hostname == 'reverseproxy' }.data['ssh_port'] = $ALT_SSH_PORT
desc 'Makes configurations needed before the bootstrap phase'
task :preconfig => ssh_config_file do
  preconfig_file = "tmp/preconfig.#{$SPB_ENV}.stamp"
  if File.exist?(preconfig_file)
    puts "I: preconfig already done."
    puts "I: delete #{preconfig_file} to force running again"
  else
    sh 'scp', '-F', ssh_config_file, 'utils/reverseproxy_ssh_setup', 'reverseproxy.unconfigured:/tmp'
    sh 'ssh', '-F', ssh_config_file, 'reverseproxy.unconfigured', 'sudo', '/tmp/reverseproxy_ssh_setup', $ALT_SSH_PORT.to_s

    File.open(preconfig_file, 'w') do |f|
      f.puts($ALT_SSH_PORT)
    end
  end
end

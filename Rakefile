require 'yaml'

begin
  load 'local.rake'
rescue LoadError
  # nothing
end

$SPB_ENV = ENV.fetch('SPB_ENV', 'local')

ssh_config_file = "config/#{$SPB_ENV}/ssh_config"
ips_file = "config/#{$SPB_ENV}/ips.yaml"
config_file = "config/#{$SPB_ENV}/config.yaml"
iptables_file = "config/#{$SPB_ENV}/iptables-filter-rules"

ENV['CHAKE_TMPDIR'] = "tmp/chake.#{$SPB_ENV}"
ENV['CHAKE_SSH_CONFIG'] = ssh_config_file

chake_rsync_options = ENV['CHAKE_RSYNC_OPTIONS'].to_s.clone
chake_rsync_options += ' --exclude backups'
chake_rsync_options += ' --exclude src'
ENV['CHAKE_RSYNC_OPTIONS'] = chake_rsync_options

if $SPB_ENV == 'lxc'
  system("mkdir -p config/lxc; sudo lxc-ls -f -F name,ipv4 | sed -e '/^softwarepublico/ !d; s/softwarepublico_//; s/_[0-9_]*/:/ ' > #{ips_file}.new")
  begin
    ips = YAML.load_file("#{ips_file}.new")
    raise ArgumentError unless ips.is_a?(Hash)
    FileUtils.mv ips_file + '.new', ips_file
  rescue Exception => ex
    puts ex.message
    puts
    puts "Q: did you boot the containers first?"
    exit
  end
  config = YAML.load_file('config/local/config.yaml')
  config['external_ip'] = ips['reverseproxy']
  config['relay_ip'] = ips['email']
  File.open(config_file, 'w') do |f|
    f.puts(YAML.dump(config))
  end

  File.open('config/lxc/iptables-filter-rules', 'w') do |f|
    lxc_host_bridge_name = `awk '{ if ($1 == "lxc.network.link") { print($3) } }' /etc/lxc/default.conf`.strip
    lxc_host_bridge_ip = ` /sbin/ifconfig #{lxc_host_bridge_name} | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1 }' `.strip
    f.puts "-A INPUT -s #{lxc_host_bridge_ip} -p tcp -m state --state NEW --dport 22 -j ACCEPT"
    f.puts "-A INPUT -s #{lxc_host_bridge_ip} -p tcp -m state --state NEW --dport 5555 -j ACCEPT"
  end
end

require 'chake'

if Gem::Version.new(Chake::VERSION) < Gem::Version.new('0.10')
  fail "Please upgrade to chake 0.10+"
end

ips ||= YAML.load_file(ips_file)
config ||= YAML.load_file(config_file)
firewall ||= File.open(iptables_file).read
config['keep_yum_cache'] = ENV['keep_yum_cache'] ? true : false
$nodes.each do |node|
  node.data['environment'] = $SPB_ENV
  node.data['config'] = config
  node.data['peers'] = ips
  node.data['firewall'] = firewall
end

# In the absence of a dedicated munin master, reverseproxy will do that.
if !config['munin_master']
  config['munin_master'] = ips['reverseproxy']
  $nodes.find { |node| node.hostname == 'reverseproxy' }.data['run_list'] << 'role[monitoring_server]'
end

task :console do
  require 'pry'
  binding.pry
end

task :test do
  sh "SPB_ENV=#{$SPB_ENV} ./test/run_all"
end

file 'ssh_config.erb'
if ['local', 'lxc'].include?($SPB_ENV)
  file ssh_config_file => ['nodes.yaml', ips_file, 'ssh_config.erb', 'Rakefile'] do |t|
    require 'erb'
    template = ERB.new(File.read('ssh_config.erb'))
    File.open(t.name, 'w') do |f|
      f.write(template.result(binding))
    end
    puts 'ERB %s' % t.name
  end
end
task 'bootstrap_common' => ssh_config_file
task 'run_input' => ssh_config_file

desc 'Downloads latest system backups to backups directory. WARNING: This overrides anything written in the backups directory'
task :backup => ssh_config_file do
  # setup
  sh 'rm', '-rf', 'backups'
  sh 'mkdir', '-p', 'backups'
  # integration
  sh 'ssh', '-F', ssh_config_file, 'integration', 'sudo', 'chmod a+xr /.snapshots'
  sh 'scp', '-F', ssh_config_file, 'integration:/.snapshots/hourly.0/spb/*', 'backups/'
  # social
  sh 'ssh', '-F', ssh_config_file, 'social', 'sudo', 'chmod a+xr /.snapshots'
  sh 'scp', '-F', ssh_config_file, 'social:/.snapshots/hourly.0/spb/*', 'backups/'
end

desc 'Restores content saved in the backups directory to the target env. WARNING: This will drop all the current databases'
task :restore => [ssh_config_file, config_file] do
  # setup
  sh 'ssh', '-F', ssh_config_file, 'integration', 'sudo', 'rm -rf /tmp/backups'
  sh 'ssh', '-F', ssh_config_file, 'integration', 'sudo', 'systemctl stop colab'
  sh 'ssh', '-F', ssh_config_file, 'social', 'sudo', 'rm -rf /tmp/backups'
  sh 'ssh', '-F', ssh_config_file, 'social', 'sudo', 'systemctl stop noosfero'
  sh 'ssh', '-F', ssh_config_file, 'database', 'sudo', 'sudo -u postgres dropdb colab 2> /dev/null'
  sh 'ssh', '-F', ssh_config_file, 'database', 'sudo', 'sudo -u postgres createdb colab --owner colab 2> /dev/null'
  sh 'ssh', '-F', ssh_config_file, 'database', 'sudo', 'sudo -u postgres dropdb noosfero 2> /dev/null'
  sh 'ssh', '-F', ssh_config_file, 'database', 'sudo', 'sudo -u postgres createdb noosfero --owner noosfero 2> /dev/null'
  #integration
  sh 'scp', '-r', '-F', ssh_config_file, 'backups', 'integration:/tmp'
  sh 'scp', '-F', ssh_config_file, 'utils/migration/restore_integration.sh', 'integration:/tmp'
  sh 'ssh', '-F', ssh_config_file, 'integration', 'sudo', "env SPB_URL=#{config['lists_hostname']} /tmp/restore_integration.sh"
  #social
  sh 'scp', '-r', '-F', ssh_config_file, 'backups', 'social:/tmp'
  sh 'scp', '-F', ssh_config_file, 'utils/migration/restore_social.sh', 'social:/tmp'
  sh 'ssh', '-F', ssh_config_file, 'social', 'sudo', '/tmp/restore_social.sh'
  sh 'ssh', '-F', ssh_config_file, 'social', 'sudo', 'systemctl start noosfero'
  sh 'ssh', '-F', ssh_config_file, 'integration', 'sudo', 'systemctl start colab'
end

namespace :export_data do
  task :noosfero => [ssh_config_file, config_file] do
    # setup
    sh 'mkdir', '-p', 'exported_data'
    #social
    sh 'ssh', '-F', ssh_config_file, 'social', 'cd /usr/lib/noosfero/ && sudo -u noosfero RAILS_ENV=production bundle exec rake export:catalog:csv'
    sh 'scp', '-F', ssh_config_file, 'social:/tmp/software_catalog_csvs.tar.gz', 'exported_data/'
  end
end

task :bootstrap_common => :check_dependencies

unless ENV['nodeps']
  task 'converge:integration' => 'converge:database'
  task 'converge:integration' => 'converge:social'
  task 'converge:social'      => 'converge:database'
  task 'upload:reverseproxy'  => 'doc'
end

$ALT_SSH_PORT = config.fetch('alt_ssh_port', 2222)

$nodes.find { |n| n.hostname == 'reverseproxy' }.data['ssh_port'] = $ALT_SSH_PORT
desc 'Makes configurations needed before the bootstrap phase'
task :preconfig => ssh_config_file do
  sh 'mkdir', '-p', 'tmp/'
  preconfig_file = "tmp/preconfig.#{$SPB_ENV}.stamp"
  if File.exist?(preconfig_file)
    puts "I: preconfig already done."
    puts "I: delete #{preconfig_file} to force running again"
  else
    sh 'scp', '-F', ssh_config_file, 'utils/reverseproxy_ssh_setup', 'reverseproxy.unconfigured:/tmp'
    sh 'ssh', '-F', ssh_config_file, 'reverseproxy.unconfigured', 'sudo', '/tmp/reverseproxy_ssh_setup', $ALT_SSH_PORT.to_s, ips['reverseproxy'], ips['integration']

    File.open(preconfig_file, 'w') do |f|
      f.puts($ALT_SSH_PORT)
    end
  end
end

Dir.glob('tasks/*.rake').each { |f| load f }

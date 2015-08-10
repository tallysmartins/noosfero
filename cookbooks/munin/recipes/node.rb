package 'munin-node'

service 'munin-node' do
  action [:enable, :start]
end

directory '/usr/local/share/munin/plugins' do
  recursive true
end
cookbook_file '/usr/local/share/munin/plugins/packetloss' do
  mode 0755
end

node['peers'].each do |hostname,ip|
  link '/etc/munin/plugins/packetloss_' + hostname do
    to '/usr/local/share/munin/plugins/packetloss'
  end
end

bash "allow connections from munin master" do
  ip = node['config']['munin_master']
  code "echo 'cidr_allow #{ip}/32' >> /etc/munin/munin-node.conf"
  not_if "grep 'cidr_allow #{ip}/32' /etc/munin/munin-node.conf"
  notifies :restart, 'service[munin-node]'
end

bash "set munin-node hostname" do
  hostname = node['fqdn']
  code "sed -i -e '/^host_name\s*localhost/d; $a host_name #{hostname}' /etc/munin/munin-node.conf"
  not_if "grep 'host_name #{hostname}' /etc/munin/munin-node.conf"
  notifies :restart, 'service[munin-node]'
end

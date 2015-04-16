package 'nginx'

service 'nginx' do
  action :enable
  supports :restart => true
end

################################
#  SELinux: allow nginx to use log files
################################
cookbook_file '/etc/selinux/local/nginx.te' do
  notifies :run, 'execute[selinux-nginx]'
end

execute 'selinux-nginx' do
  command 'selinux-install-module /etc/selinux/local/nginx.te'
  action  :nothing
end

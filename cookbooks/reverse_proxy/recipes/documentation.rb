docs = File.expand_path("../../../docs/_build/#{node['environment']}/html", File.dirname(__FILE__))

execute 'rsync::docs' do
  command "rsync -avp --delete #{docs}/ /srv/doc/"
end


####################################################
#  SELinux: allow nginx to to read doc files
####################################################
cookbook_file '/etc/selinux/local/spbdoc.te' do
  notifies :run, 'execute[selinux-spbdoc]'
end
execute 'selinux-spbdoc' do
  command 'selinux-install-module /etc/selinux/local/spbdoc.te'
  action :nothing
end

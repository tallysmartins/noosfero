cookbook_file '/etc/apt/sources.list.d/contrib.list' do
  notifies :run, 'execute[apt-update]', :immediately
end

execute 'apt-update' do
  command 'apt-get update'
  action :nothing
end
package 'virtualbox'

package 'vagrant'
package 'rake'
package 'shunit2'

# FIXME not in the archive yet
# package 'chake'

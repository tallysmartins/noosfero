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

# for building colab-deps:
package 'python-virtualenv'
package 'libpq-dev'
package 'gettext'
package 'libxml2-dev'
package 'libxslt1-dev'
package 'libssl-dev'
package 'libffi-dev'
package 'libjpeg-dev'
package 'zlib1g-dev'
package 'libfreetype6-dev'
package 'python-dev'
package 'libyaml-dev'
package 'libev-dev'

# FIXME not in the archive yet
# package 'chake'

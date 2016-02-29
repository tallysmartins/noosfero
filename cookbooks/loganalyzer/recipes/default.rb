LOGANALYZER_TAR='loganalyzer-3.6.5.tar.gz'
LOGANALYZER_TAR_PATH='/tmp/'+LOGANALYZER_TAR
LOGANALYZER_SRC='/usr/share/nginx/html/loganalyzer'

package 'php'
package 'php-fpm'
package 'php-mysql'
package 'mariadb-server'
package 'nginx'

service 'nginx'
service 'php-fpm' do
  action [:enable, :start]
end
service 'mariadb' do
  action [:enable,:start]
end

template '/etc/nginx/conf.d/loganalyzer.conf' do
  source 'nginx.conf.erb'
  notifies :reload, 'service[nginx]'
  notifies :reload, 'service[php-fpm]'
end

execute 'getting-loganalizer' do
  command 'wget http://download.adiscon.com/loganalyzer/loganalyzer-3.6.5.tar.gz'
  cwd '/tmp'
end

execute 'tar-extraction' do
  command 'tar zxvf ' + LOGANALYZER_TAR
  cwd '/tmp'
  user 'root'
end

execute 'cp-loganalyzer-files' do
  command 'cp -r -n loganalyzer-3.6.5/src/ ' + LOGANALYZER_SRC
  cwd '/tmp'
  user 'root'
end

file LOGANALYZER_SRC+'/config.php' do
  owner 'root'
  group 'root'
  mode '0666'
end

execute 'allowing-config-permission' do
  command 'semanage fcontext -a -t httpd_sys_rw_content_t ' + LOGANALYZER_SRC + '/config.php'
  user 'root'
end

execute 'enable-config-permission' do
  command 'restorecon -v ' + LOGANALYZER_SRC + '/config.php'
  user 'root'
end

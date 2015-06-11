JENKINS_CLI = '/var/cache/jenkins/war/WEB-INF/jenkins-cli.jar'

execute 'jenkins_repo' do
  command 'wget -q -O - http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key | sudo apt-key add -'
  not_if 'apt-key list | grep D50582E6'
end

execute 'apt_sources' do
  command 'echo "deb http://pkg.jenkins-ci.org/debian-stable binary/" >> /etc/apt/sources.list && apt-get update'
  not_if 'cat /etc/apt/sources.list | grep jenkins-ci'
end

package 'jenkins'

service 'jenkins' do
  action [:enable, :start]
end

package 'nginx'

service 'nginx' do
  action [:enable, :start]
end

file '/etc/nginx/sites-available/default' do
  action :delete
end

cookbook_file 'nginx' do
  path '/etc/nginx/sites-available/jenkins'
end

file '/etc/nginx/sites-enabled/default' do
  action :delete
end

link '/etc/nginx/sites-enabled/jenkins' do
  to '/etc/nginx/sites-available/jenkins'
  not_if 'test -L /etc/nginx/sites-enabled/jenkins'
  notifies :restart, 'service[nginx]'
end

package 'git'

plugins = ['git-client', 'git-server', 'build-blocker-plugin', 'greenballs', 'view-job-filters', 'gitlab-plugin']

plugins.each do |plugin|
  execute "install jenkins plugin #{plugin}" do
    command "java -jar #{JENKINS_CLI} -s http://localhost/ install-plugin #{plugin}"
    retries 5
    retry_delay 10
    not_if "java -jar #{JENKINS_CLI} -s http://localhost/ list-plugins | grep ^#{plugin}"
    notifies :restart, 'service[jenkins]'
  end
end

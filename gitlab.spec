%define pid_dir %{_localstatedir}/run/redis
%define pid_file %{pid_dir}/redis.pid

Summary: gitlab
Name: gitlab
Version: 7.4
Release: 1
License: BSD
#Group: Applications/Multimedia
#URL: http://redis.io/
Source0: gitlab-%{version}.tar.gz
Source1: gitlab-ce-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
Requires: nginx, postgresql-server, gitlab-deps

BuildRequires: curl, zlib-devel, libyaml-devel, openssl-devel, libffi-devel, openssh-server, logrotate, libxml2-devel, libxslt-devel, readline-devel, ncurses-devel, libcurl-devel, python-docutils, gdbm-devel, gitlab-deps

#Requires(post): /sbin/chkconfig /usr/sbin/useradd
#Requires(preun): /sbin/chkconfig, /sbin/service
#Requires(postun): /sbin/service
Provides: gitlab
%if 0%{?suse_version} >= 1210
BuildRequires: systemd
%endif 


%description


%prep
echo "Fase de preparacao"
%setup

%pre
adduser git
echo "Fase de pre"
service postgresql initdb
service postgresql start
sudo -u postgres psql -d template1 << EOF
CREATE USER git CREATEDB;
CREATE DATABASE gitlabhq_production OWNER git;
\q
EOF

export PATH=$PATH:/usr/lib/gitlab/vendor/bundle/ruby/bin

%build

cp config/gitlab.yml.example config/gitlab.yml
cp config/unicorn.rb.example config/unicorn.rb
cp config/initializers/rack_attack.rb.example config/initializers/rack_attack.rb
cp config/database.yml.postgresql config/database.yml

#bundle install --deployment --without development test mysql aws 

# Run the installation task for gitlab-shell (replace `REDIS_URL` if needed):
#bundle exec rake gitlab:shell:install REDIS_URL="redis://localhost:6379" RAILS_ENV=production

# By default, the gitlab-shell config is generated from your main GitLab config.
# You can review (and modify) the gitlab-shell config as follows:
### vim /home/git/gitlab-shell/config.yml

bundle exec rake gitlab:setup RAILS_ENV=production
bundle exec rake assets:precompile RAILS_ENV=production

echo "\t\t\tFim da fase de build"
pwd

%install
echo "#########Criando diretorio %{buildroot}%{_libdir}/gitlab"
mkdir -p %{buildroot}/usr/lib/gitlab/
cp -r . %{buildroot}/usr/lib/gitlab/


%post

%preun

%postun

userdel git

sudo -u postgres psql -d template1 << EOF
DROP DATABASE [ IF EXISTS ] gitlabhq_production;
DROP USER [ IF EXISTS ] git;
\q
EOF

%clean
%{__rm} -rf %{buildroot}

%files
/usr/lib/gitlab/

#%defattr(-, root, root, 0755)
#%doc deps/lua/doc/*.html
#%{_sbindir}/redis-server
#%{_bindir}/redis-benchmark
#%{_bindir}/redis-cli
#%{_unitdir}/redis.service
#%config(noreplace) %{_sysconfdir}/redis.conf
#%{_sysconfdir}/logrotate.d/redis
#%dir %attr(0770,redis,redis) %{_localstatedir}/lib/redis
#%dir %attr(0755,redis,redis) %{_localstatedir}/log/redis
#%dir %attr(0755,redis,redis) %{_localstatedir}/run/redis

%changelog

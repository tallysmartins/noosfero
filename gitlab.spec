Name:    gitlab
Version: 7.5.2
Release: 1%{?dist}
Summary: Software Development Platform
Group:   Development/Tools
License: Expat
URL:     https://beta.softwarepublico.gov.br/gitlab/softwarepublico/gitlab
Source0: %{name}-%{version}.tar.gz

BuildRequires: gitlab-deps,postgresql-server, postgresql-devel
Requires: gitlab-deps, postgresql-server, git

%description
GitLab

%prep
%autosetup

%pre
adduser git
service postgresql initdb
service postgresql start
sudo -u postgres psql -d template1 << EOF
CREATE USER git CREATEDB;
CREATE DATABASE gitlabhq_production OWNER git;
\q
EOF 

%build
# make %{?_smp_mflags}

%install
cp config/gitlab.yml.example config/gitlab.yml
cp config/unicorn.rb.example config/unicorn.rb
cp config/initializers/rack_attack.rb.example config/initializers/rack_attack.rb
cp config/database.yml.postgresql config/database.yml 

mkdir -p %{buildroot}/usr/lib/gitlab
cp -r app bin config config.ru db doc GITLAB_SHELL_VERSION lib Procfile public Rakefile vendor VERSION %{buildroot}/usr/lib/gitlab/

%post

cd /usr/lib/gitlab/
cp vendor/Gemfile* .
bundle exec rake gitlab:setup RAILS_ENV=production

%postun
userdel git 

sudo -u postgres psql -d template1 << EOF 
DROP DATABASE gitlabhq_production;
DROP USER git;
\q
EOF

%files
/usr/lib/gitlab
%doc

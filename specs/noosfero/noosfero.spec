%define writable_dirs javascripts/cache stylesheets/cache articles image_uploads thumbnails

Name:    noosfero
Version: 1.1~rc2
Release: 1%{?dist}
Summary: Social Networking Platform
Group:   Applications/Publishing
License: AGPLv3
URL:     http://noosfero.org
Source0: %{name}-%{version}.tar.gz
BuildArch: noarch
BuildRequires: noosfero-deps
Requires: noosfero-deps, po4a, tango-icon-theme

%description
Noosfero is a web platform for social and solidarity economy networks with blog,
e-Porfolios, CMS, RSS, thematic discussion, events agenda and collective
inteligence for solidarity economy in the same system! Get to know, use it,
participate and contribute to this free software project!

%prep
%setup -q

%build

ln -sf /usr/lib/noosfero/Gemfile .
ln -sf /usr/lib/noosfero/Gemfile.lock .
ln -sf /usr/lib/noosfero/.bundle .
ln -sfT /usr/lib/noosfero/vendor/bundle vendor/bundle
bundle exec rake -f Rakefile.release noosfero:translations:compile

%install
mkdir -p %{buildroot}/usr/lib/noosfero

# install noosfero tree
cp -r . %{buildroot}/usr/lib/noosfero/
rm %{buildroot}/usr/lib/noosfero/{Gemfile,Vagrantfile,*.md,gitignore.example,public/dispatch.fcgi,public/dispatch.cgi,public/dispatch.rb}

# install config files
mkdir -p %{buildroot}/etc/init.d
cp etc/init.d/noosfero %{buildroot}/etc/init.d/

mkdir -p %{buildroot}/etc/noosfero/plugins
ln -sf /etc/noosfero/database.yml %{buildroot}/usr/lib/noosfero/config/database.yml
ln -sf /etc/noosfero/thin.yml %{buildroot}/usr/lib/noosfero/config/thin.yml
ln -sf /etc/noosfero/plugins %{buildroot}/usr/lib/noosfero/config/plugins

# symlink needed bits in public/
for dir in %{writable_dirs}; do
  ln -s /var/lib/noosfero/public/$dir %{buildroot}/usr/lib/noosfero/public/$dir
done
ln -s /var/tmp/noosfero %{buildroot}/usr/lib/noosfero/tmp
ln -s /var/log/noosfero %{buildroot}/usr/lib/noosfero/log

# default themes
ln -s noosfero   %{buildroot}/usr/lib/noosfero/public/designs/themes/default
ln -s tango      %{buildroot}/usr/lib/noosfero/public/designs/icons/default


cat > %{buildroot}/etc/noosfero/thin.yml <<EOF
---
chdir: /usr/lib/noosfero
environment: production
address: 0.0.0.0
port: 3000
timeout: 30
log: log/thin.log
pid: tmp/pids/thin.pid
max_conns: 1024
max_persistent_conns: 512
require: []
wait: 30
daemonize: true
EOF

cat > %{buildroot}/etc/noosfero/database.yml <<EOF
production:
  adapter: postgresql
  encoding: unicode
  database: noosfero_production
  username: noosfero
  host: localhost
  port: 5432
EOF

mkdir -p %{buildroot}/etc/default
cat > %{buildroot}/etc/default/noosfero <<EOF
NOOSFERO_DIR="/usr/lib/noosfero"
NOOSFERO_USER="noosfero"
NOOSFERO_DATA_DIR="/var/lib/noosfero"
EOF

%post
groupadd noosfero || true
if ! id noosfero; then
  adduser noosfero --system -g noosfero --shell /bin/sh --home-dir /usr/lib/noosfero
fi

for dir in %{writable_dirs}; do
  mkdir -p /var/lib/noosfero/public/$dir
done
chown -R noosfero:noosfero /var/lib/noosfero

/etc/init.d/noosfero setup

cd /usr/lib/noosfero/

if [ -x /usr/bin/postgres ]; then
  if [ `systemctl is-active postgresql`!="active" ]; then
    postgresql-setup initdb || true
    systemctl start postgresql
  fi

  su postgres -c "createuser noosfero -S -d -R"
  su noosfero -c "createdb noosfero_production"

  cd /usr/lib/noosfero/
  su noosfero -c "RAILS_ENV=production bundle exec rake db:schema:load"
  su noosfero -c "RAILS_ENV=production SCHEMA=/dev/null bundle exec rake db:migrate"
  su noosfero -c "RAILS_ENV=production bundle exec rake db:data:minimal"
fi

%preun
service noosfero stop
chkconfig --del noosfero

%files
/usr/lib/noosfero
/etc/init.d/noosfero
%config(noreplace) /etc/default/noosfero
%config(noreplace) /etc/noosfero/database.yml
%config(noreplace) /etc/noosfero/thin.yml
%doc

Name:    noosfero
Version: 1.0
Release: 1%{?dist}
Summary: Software Development Platform
Group:   Development/Tools
License: GNU GPLv3
URL:     http://noosfero.org
Source0: %{name}-%{version}.tar.gz
Patch0:  %{name}p0.patch
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
grep -rl '/usr/bin/ruby1.8' . | xargs --no-run-if-empty sed -i -e '1 s|.*|#!/usr/bin/ruby|'
%patch0 -p1

%build

%install
mkdir -p %{buildroot}/var/lib/noosfero/plugins
mkdir -p %{buildroot}/var/lib/noosfero/public
mkdir -p %{buildroot}/usr/lib/noosfero
mv plugins %{buildroot}/var/lib/noosfero/
mv doc %{buildroot}/var/lib/noosfero/
mv public %{buildroot}/var/lib/noosfero/
rm Gemfile Vagrantfile *.md gitignore.example
cp -r . %{buildroot}/usr/lib/noosfero/


%post
groupadd noosfero || true
if ! id noosfero; then
  adduser noosfero --system -g noosfero --shell /bin/sh --home-dir /usr/lib/noosfero
fi

cp /usr/lib/noosfero/etc/init.d/noosfero /etc/init.d/
/etc/init.d/noosfero setup

mkdir -p /var/lib/noosfero/locale
mkdir -p /etc/noosfero

chown -R noosfero:noosfero /var/lib/noosfero

ln -s /var/lib/noosfero/locale /usr/lib/noosfero/locale
ln -s /var/lib/noosfero/plugins /usr/lib/noosfero/plugins
ln -s /var/lib/noosfero/doc /usr/lib/noosfero/doc
ln -s /var/lib/noosfero/public /usr/lib/noosfero/public

ln -s /etc/noosfero/database.yml /usr/lib/noosfero/config/
ln -s /etc/noosfero/thin.yml /usr/lib/noosfero/config/

cd /usr/lib/noosfero/
bundle exec thin -C /etc/noosfero/thin.yml -e production config

cat > /etc/noosfero/database.yml <<EOF
production:
  adapter: postgresql
  encoding: unicode
  database: noosfero_production
  username: noosfero
  host: localhost
  port: 5432
EOF

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
/var/lib/noosfero
%doc

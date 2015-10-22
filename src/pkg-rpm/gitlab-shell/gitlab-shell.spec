Name:		gitlab-shell
Version:	2.4.0
Release:	5.1
Summary:	Software Development Platform

Group:		Development/Tools
License:	Expat
URL:		https://gitlab.com/gitlab-org/gitlab-shell
Source0:	%{name}-%{version}.tar.gz
BuildArch:	noarch

# BuildRequires:
Requires:	ruby >= 1.9, redis

%description
Gitlab-shell

%prep
%setup -q

%build
cat > config.yml <<EOF
user: git
gitlab_url: "http://localhost:8080/"

http_settings:
#  user: someone
#  password: somepass
#  ca_file: /etc/ssl/cert.pem
#  ca_path: /etc/pki/tls/certs
  self_signed_cert: false

repos_path: "/var/lib/gitlab-shell/repositories/"
auth_file: "/var/lib/gitlab-shell/.ssh/authorized_keys"

redis:
  bin: /usr/bin/redis-cli
  host: 127.0.0.1
  port: 6379
  # pass: redispass # Allows you to specify the password for Redis
  #database: 0
  #socket: /var/run/redis/redis.sock # Comment out this line if you want to use TCP
  #namespace: resque:gitlab

log_file: "/var/log/gitlab-shell/gitlab-shell.log"
log_level: INFO
audit_usernames: false
EOF

%install
mkdir -p %{buildroot}/usr/lib/gitlab-shell
mkdir -p %{buildroot}/etc/gitlab-shell

mv config.yml %{buildroot}/etc/gitlab-shell
ln -s /etc/gitlab-shell/config.yml %{buildroot}/usr/lib/gitlab-shell/

cp -r .  %{buildroot}/usr/lib/gitlab-shell

%post
groupadd git || true
if ! id git; then
  adduser --system --home-dir /var/lib/gitlab-shell --gid git git
fi

mkdir -p /var/log/gitlab-shell
mkdir -p /var/lib/gitlab-shell/.ssh
mkdir -p /var/lib/gitlab-shell/repositories

chown -R git:git /var/log/gitlab-shell
chown -R git:git /var/lib/gitlab-shell

sudo -u git -H /usr/lib/gitlab-shell/bin/install

%files
/usr/lib/gitlab-shell
/etc/gitlab-shell


%changelog


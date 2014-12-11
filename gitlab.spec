Name:    gitlab
Version: 7.5.2
Release: 1%{?dist}
Summary: Software Development Platform
Group:   Development/Tools
License: Expat
URL:     https://beta.softwarepublico.gov.br/gitlab/softwarepublico/gitlab
Source0: %{name}-%{version}.tar.gz
BuildArch: noarch
BuildRequires: gitlab-deps
Requires: gitlab-deps, git

%description
GitLab

%prep
%autosetup

%build
cat > config/gitlab.yml <<EOF
production: &base
  gitlab:
    host: localhost
    port: 80 # Set to 443 if using HTTPS
    https: false # Set to true if using HTTPS
    email_from: example@example.com
    default_projects_limit: 10
    default_projects_features:
      issues: true
      merge_requests: true
      wiki: true
      snippets: false
      visibility_level: "private"  # can be "private" | "internal" | "public"
  gravatar:
    enabled: true
    plain_url: "http://cdn.libravatar.org/avatar/%{hash}?s=%{size}&d=identicon"
    ssl_url: "https://seccdn.libravatar.org/avatar/%{hash}?s=%{size}&d=identicon"
  omniauth:
    # Allow login via Twitter, Google, etc. using OmniAuth providers
    enabled: false
    allow_single_sign_on: false
    block_auto_created_users: true
    providers:
      # - { name: 'google_oauth2', app_id: 'YOUR APP ID',
      #     app_secret: 'YOUR APP SECRET',
      #     args: { access_type: 'offline', approval_prompt: '' } }
  satellites:
    path: /var/lib/gitlab/satellites
    timeout: 30
  backup:
    path: /var/lib/gitlab/backups
  gitlab_shell:
    path: /usr/lib/gitlab-shell
    repos_path: /var/lib/gitlab/repositories/
    hooks_path: /usr/lib/gitlab-shell/hooks/
    # Git over HTTP
    upload_pack: true
    receive_pack: true
  git:
    bin_path: /usr/bin/git
    max_size: 20971520 # 20.megabytes
    timeout: 10
  extra:
    ## Piwik analytics.
    # piwik_url: '_your_piwik_url'
    # piwik_site_id: '_your_piwik_site_id'

    ## Text under sign-in page (Markdown enabled)
    # sign_in_text: |
    #   ![Company Logo](http://www.companydomain.com/logo.png)
    #   [Learn more about CompanyName](http://www.companydomain.com/)
EOF

%install
mkdir -p                          %{buildroot}/etc/gitlab
mv config/gitlab.yml              %{buildroot}/etc/gitlab/gitlab.yml
cp config/unicorn.rb.example      %{buildroot}/etc/gitlab/unicorn.rb
cp config/database.yml.postgresql %{buildroot}/etc/gitlab/database.yml 

mkdir -p %{buildroot}/usr/lib/gitlab
cp -r app bin config config.ru db doc GITLAB_SHELL_VERSION lib Procfile public Rakefile vendor VERSION %{buildroot}/usr/lib/gitlab/
mv %{buildroot}/usr/lib/gitlab/config/initializers/rack_attack.rb.example %{buildroot}/usr/lib/gitlab/config/initializers/rack_attack.rb
for configfile in gitlab.yml unicorn.rb database.yml; do
  ln -s /etc/gitlab/$configfile %{buildroot}/usr/lib/gitlab/config
done
ln -s /var/log/gitlab      %{buildroot}/usr/lib/gitlab/log
ln -s /var/lib/gitlab/tmp  %{buildroot}/usr/lib/gitlab/tmp
ln -s /var/lib/gitlab/.gitlab_shell_secret %{buildroot}/usr/lib/gitlab/.gitlab_shell_secret
ln -s /var/lib/gitlab/.secret %{buildroot}/usr/lib/gitlab/.secret

%post
groupadd git || true
if ! id git; then
  adduser --system --home-dir /usr/lib/gitlab --no-create-home --gid git git
fi
if [ -x /usr/bin/postgres ]; then
  service postgresql initdb || true
  service postgresql start
  service postgresql enable
  sudo -u postgres createuser --createdb git || true
fi
mkdir -p /var/log/gitlab
chown -R git:git /var/log/gitlab
mkdir -p /var/lib/gitlab/backups
mkdir -p /var/lib/gitlab/repositories
mkdir -p /var/lib/gitlab/satellites
mkdir -p /var/lib/gitlab/tmp
chown -R git:git /var/lib/gitlab
if [ /usr/bin/redis-server ]; then
  service redis start
  service redis enable
fi

cd /usr/lib/gitlab/
yes yes | sudo -u git bundle exec rake gitlab:setup RAILS_ENV=production

%postun
#TODO Remove
sudo -u postgres psql -d template1 << EOF 
DROP DATABASE gitlabhq_production;
DROP USER git;
\q
EOF

%files
/usr/lib/gitlab
/etc/gitlab
%doc

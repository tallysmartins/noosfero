Name:    gitlab
Version: 7.6.2
Release: 9%{?dist}
Summary: Software Development Platform
Group:   Development/Tools
License: Expat
URL:     https://beta.softwarepublico.gov.br/gitlab/softwarepublico/gitlab
Source0: %{name}-%{version}.tar.gz
Patch0: avatar_url.patch
BuildArch: noarch
BuildRequires: gitlab-deps
Requires: gitlab-deps, gitlab-shell, git

%description
GitLab

%prep
%setup -q
%patch0 -p 1

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
    repos_path: /var/lib/gitlab-shell/repositories/
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
cat > config/initializers/no_asset_compile.rb <<EOF
Gitlab::Application.configure do
  # assets already compiled
  config.assets.compile = false
end
EOF

sed -i 's/\/home\/\git/\/usr\/lib/' %{buildroot}/etc/gitlab/unicorn.rb

mkdir -p %{buildroot}/usr/lib/gitlab
cp -r app bin config config.ru db doc GITLAB_SHELL_VERSION lib Procfile public Rakefile vendor VERSION %{buildroot}/usr/lib/gitlab/
mv %{buildroot}/usr/lib/gitlab/config/initializers/rack_attack.rb.example %{buildroot}/usr/lib/gitlab/config/initializers/rack_attack.rb
for configfile in gitlab.yml unicorn.rb database.yml; do
  ln -s /etc/gitlab/$configfile %{buildroot}/usr/lib/gitlab/config
done
ln -s /var/log/gitlab      %{buildroot}/usr/lib/gitlab/log
ln -s /var/lib/gitlab/tmp  %{buildroot}/usr/lib/gitlab/tmp
ln -s /var/lib/gitlab/.secret %{buildroot}/usr/lib/gitlab/.secret
ln -s /var/lib/gitlab-assets %{buildroot}/usr/lib/gitlab/public/assets
ln -s /var/lib/gitlab-uploads %{buildroot}/usr/lib/gitlab/public/uploads

%post
if [ -x /usr/bin/postgres ]; then
  service postgresql initdb || true
  service postgresql start
  sudo -u postgres createuser --createdb git || true
fi
mkdir -p /var/log/gitlab
chown -R git:git /var/log/gitlab
mkdir -p /var/lib/gitlab/backups
mkdir -p /var/lib/gitlab/satellites
mkdir -p /var/lib/gitlab/tmp
mkdir -p /var/lib/gitlab-uploads
touch /var/lib/gitlab/.gitconfig
ln -s /var/lib/gitlab/.gitconfig /usr/lib/gitlab/.gitconfig
chown -R git:git /var/lib/gitlab
chmod u+rwx,g=rx,o-rwx /var/lib/gitlab/satellites

if [ /usr/bin/redis-server ]; then
  service redis start
fi

sudo -u git -H "/usr/bin/git" config --global user.name  "GitLab"
sudo -u git -H "/usr/bin/git" config --global user.email "example@example.com"
sudo -u git -H "/usr/bin/git" config --global core.autocrlf "input"

mkdir -p /var/lib/gitlab-assets

cd /usr/lib/gitlab/
yes yes | sudo -u git bundle exec rake gitlab:setup RAILS_ENV=production
bundle exec rake assets:precompile RAILS_ENV=production

cp /usr/lib/gitlab/lib/support/init.d/gitlab /etc/init.d/gitlab
cp /usr/lib/gitlab/lib/support/init.d/gitlab.default.example /etc/default/gitlab
cp /usr/lib/gitlab/lib/support/logrotate/gitlab /etc/logrotate.d/gitlab

sed -i 's/app_root="\/home\/\$app_user\/gitlab"/app_root="\/usr\/lib\/gitlab"/' /etc/default/gitlab
sed -i 's/\/home\/\git/\/usr\/lib/' /etc/logrotate.d/gitlab

%postun
service gitlab stop

%files
/usr/lib/gitlab
/etc/gitlab
%config(noreplace) %{_sysconfdir}/gitlab/database.yml
%config(noreplace) %{_sysconfdir}/gitlab/gitlab.yml
%config(noreplace) %{_sysconfdir}/gitlab/unicorn.rb
%doc

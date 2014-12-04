Name:    gitlab
Version: 7.5.2
Release: 1%{?dist}
Summary: Software Development Platform
Group:   Development/Tools
License: Expat
URL:     https://beta.softwarepublico.gov.br/gitlab/softwarepublico/gitlab
Source0: %{name}-%{version}.tar.gz

BuildRequires: gitlab-deps
Requires: gitlab-deps

%description
GitLab

%prep
%autosetup

%build
# make %{?_smp_mflags}

%install
mkdir -p %{buildroot}/usr/lib/gitlab
cp -r app bin config config.ru db doc GITLAB_SHELL_VERSION lib Procfile public Rakefile vendor VERSION %{buildroot}/usr/lib/gitlab/

%files
/usr/lib/gitlab
%doc

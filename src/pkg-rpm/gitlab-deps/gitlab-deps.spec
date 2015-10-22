Name:    gitlab-deps
Version: 7.5.4
Release: 2.1
Summary: Ruby dependencies for Gitlab
Group:   Development/Tools
License: Various
URL:     https://beta.softwarepublico.gov.br/gitlab/softwarepublico/gitlab-deps
Source0: %{name}-%{version}.tar.gz

BuildRequires: make, gcc, gcc-c++, ruby, ruby-devel, rubygem-bundler, libicu-devel, cmake, mysql-devel, postgresql-devel
Requires: ruby, rubygem-bundler

%description
Dependencies for GitLab

%prep
%autosetup

%build
make %{?_smp_mflags}

%install
%make_install

%files
/usr/lib/gitlab
%doc

%changelog

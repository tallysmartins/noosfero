Name:    prezento-spb-deps
Version: 0.8
Release: 1%{?dist}
Summary: Ruby dependencies for prezento
Group:   Development/Tools
License: Various
URL:     http://mezuro.org
Source0: %{name}-%{version}.tar.gz

BuildRequires: make, gcc, gcc-c++, ruby, ruby-devel, rubygem-bundler, postgresql-devel, libxml2-devel, libxslt-devel, sqlite-devel, git
Requires: ruby, rubygem-bundler

%description
Ruby dependencies for prezento

%prep
%autosetup

%build
make %{?_smp_mflags}

%install
%make_install

%files
/usr/lib/prezento-spb
%doc

%changelog

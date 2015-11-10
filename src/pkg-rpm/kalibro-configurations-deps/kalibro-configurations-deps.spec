Name:    kalibro-configurations-deps
Version: 1.0
Release: 0
Summary: Ruby dependencies for kalibro-configurations
Group:   Development/Tools
License: Various
URL:     http://mezuro.org
Source0: %{name}-%{version}.tar.gz

BuildRequires: make, gcc, gcc-c++, ruby, ruby-devel, rubygem-bundler, postgresql-devel, libxml2-devel, libxslt-devel, sqlite-devel
Requires: ruby, rubygem-bundler

%description
Ruby dependencies for kalibro-configurations.

%prep
%autosetup

%build
make %{?_smp_mflags}

%install
%make_install

%files
/usr/lib/kalibro-configurations
%doc

%changelog

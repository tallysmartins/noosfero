Name:    prezento-spb-deps
Version: 0.8.3.colab
Release: 1
Summary: Ruby dependencies for prezento
Group:   Development/Tools
License: Various
URL:     http://mezuro.org
Source0: %{name}-%{version}.tar.gz

BuildRequires: make, gcc, gcc-c++, ruby, ruby-devel
BuildRequires: rubygem-bundler, postgresql-devel
BuildRequires: libxml2-devel, libxslt-devel, sqlite-devel
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

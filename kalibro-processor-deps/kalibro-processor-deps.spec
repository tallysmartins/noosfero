Name:    kalibro-processor-deps
Version: 1.0+really0.10.0
Release: 1%{?dist}
Summary: Ruby dependencies for kalibro-processor
Group:   Development/Tools
License: Various
URL:     http://mezuro.org
Source0: %{name}-%{version}.tar.gz
BuildRequires: make, gcc, gcc-c++, ruby, ruby-devel
BuildRequires: rubygem-bundler, postgresql-devel
BuildRequires: libxml2-devel, libxslt-devel, sqlite-devel
Requires: ruby, rubygem-bundler

%description
Ruby dependencies for kalibro-processor.

%prep
%autosetup

%build
make %{?_smp_mflags}

%install
%make_install

%files
/usr/lib/kalibro-processor
%doc

%changelog

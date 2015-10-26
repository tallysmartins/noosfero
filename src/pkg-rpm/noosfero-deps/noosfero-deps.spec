Name:    noosfero-deps
Version: 1.3
Release: 5.1
Summary: Ruby dependencies for Noosfero
Group:   Development/Tools
License: Various
URL:     http://noosfero.org
Source0: %{name}-%{version}.tar.gz

BuildRequires: make, gcc, gcc-c++, ruby, ruby-devel, rubygem-bundler, libicu-devel, cmake, mysql-devel, postgresql-devel, ImageMagick-devel, libxml2-devel, libxslt-devel
Requires: ruby, rubygem-bundler

%description
Ruby dependencies for Noosfero.
Noosfero is a web platform for social and solidarity economy networks with blog,
e-Porfolios, CMS, RSS, thematic discussion, events agenda and collective
inteligence for solidarity economy in the same system! Get to know, use it,
participate and contribute to this free software project!

%prep
%autosetup

%build
make %{?_smp_mflags}

%install
%make_install

%files
/usr/lib/noosfero
%doc

%changelog

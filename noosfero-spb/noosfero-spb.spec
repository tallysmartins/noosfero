Name:    noosfero-spb
Version: 3.3
Release: 1%{?dist}
Summary: SPB-specific Noosfero plugins and themes
Group:   Applications/Publishing
License: AGPLv3
URL:     https://beta.softwarepublico.gov.br/gitlab/softwarepublico/noosfero-spb
Source0: %{name}-%{version}.tar.gz
BuildArch: noarch

%description
This package contains Noosfero plugins and themes that are specific to the
Software Público Brasileiro platform.

%prep
%setup -q

%build
make

%install
make install DESTDIR=%{buildroot}

%files
/usr/lib/noosfero

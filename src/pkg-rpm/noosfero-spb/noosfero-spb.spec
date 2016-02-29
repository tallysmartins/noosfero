Name:    noosfero-spb
Version: 5.0a9
Release: 1
Summary: SPB-specific Noosfero plugins and themes
Group:   Applications/Publishing
License: AGPLv3
URL:     https://beta.softwarepublico.gov.br/gitlab/softwarepublico/noosfero-spb
Source0: %{name}-%{version}.tar.gz
BuildArch: noarch
BuildRequires: gettext

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

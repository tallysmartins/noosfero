#
# spec file for package colab-spb-theme
#
# Copyright (c) 2015 SUSE LINUX GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#


Name:           colab-spb-theme
Version:        0.2.0
Summary:        SPB-specific Colab theme
License:        GPL-3.0
Group:          Applications/Publishing
Url:            https://portal.softwarepublico.gov.br/gitlab/softwarepublico/colab-spb-theme-plugin
Source0:        %{name}-%{version}.tar.gz
BuildRequires:  colab >= 1.11
BuildRequires:  cronie-anacron
Requires:       colab >= 1.11
BuildArch:      noarch

%description
This package contains Colab theme for Software Público Brasileiro platform.

%prep
%setup -q

%build
make %{?_smp_mflags}

%install

install -d  %{buildroot}%{_sysconfdir}/colab/settings.d/

cat > %{buildroot}/etc/colab/settings.d/spb_theme.py << EOF
COLAB_STATICS=['/usr/lib/colab/colab-spb-theme/colab_spb_theme/static']
COLAB_TEMPLATES=('/usr/lib/colab/colab-spb-theme/colab_spb_theme/templates',)
EOF

make DESTDIR=%{buildroot} install %{?_smp_mflags}

%post
yes yes | colab-admin collectstatic

%files
%defattr(-,root,root)
/usr/lib/colab
%{_sysconfdir}/colab

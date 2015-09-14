Name:    colab-spb-theme
Version: 0.2.0
Release: 1
Summary: SPB-specific Colab theme
Group:   Applications/Publishing
License: GPLv3
URL:     https://portal.softwarepublico.gov.br/gitlab/softwarepublico/colab-spb-theme-plugin
Source0: %{name}-%{version}.tar.gz
BuildArch: noarch
BuildRequires: colab >= 1.11
Requires: colab >= 1.11
%description
This package contains Colab theme for Software Público Brasileiro platform.

%prep
%setup -q

%build
make

%install

install -d  %{buildroot}/etc/colab/settings.d/

cat > %{buildroot}/etc/colab/settings.d/spb_theme.py << EOF
COLAB_STATICS=['/usr/lib/colab/colab-spb-theme/colab_spb_theme/static']
COLAB_TEMPLATES=('/usr/lib/colab/colab-spb-theme/colab_spb_theme/templates',)
EOF

make install DESTDIR=%{buildroot}

%post
yes yes | colab-admin collectstatic

%files
/usr/lib/colab
/etc/colab

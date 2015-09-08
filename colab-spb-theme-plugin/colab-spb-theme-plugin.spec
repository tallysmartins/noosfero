Name:    colab-spb-theme-plugin
Version: 0.2
Release: 1
Summary: SPB-specific Colab theme
Group:   Applications/Publishing
License: GPLv3
URL:     https://portal.softwarepublico.gov.br/gitlab/softwarepublico/colab-spb-theme-plugin
Source0: %{name}-%{version}.tar.gz
BuildArch: noarch
BuildRequires: colab >= 1.10
%description
This package contains Colab theme for Software Público Brasileiro platform.

%prep
%setup -q

%build
make

%install

install -d  %{buildroot}/etc/colab/settings.d/

cat > %{buildroot}/etc/colab/settings.d/spb_theme.py << EOF
COLAB_STATICS=['/usr/lib/colab/colab-spb-theme-plugin/src/colab_spb_theme/static']
COLAB_TEMPLATES=('/usr/lib/colab/colab-spb-theme-plugin/src/colab_spb_theme/templates',)
EOF

make install DESTDIR=%{buildroot}

%files
/usr/lib/colab
/etc/colab

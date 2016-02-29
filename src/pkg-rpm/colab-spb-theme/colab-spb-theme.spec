Name:           colab-spb-theme
Version:        5.0a9
Release:        1
Summary:        SPB-specific Colab theme
License:        GPL-3.0
Group:          Applications/Publishing
Url:            https://softwarepublico.gov.br/gitlab/softwarepublico/colab-spb-theme-plugin
Source0:        %{name}-%{version}.tar.gz
Requires:       colab >= 1.12.5
BuildArch:      noarch

%description
This package contains Colab theme for Software Público Brasileiro platform.

%prep
%setup -q

%build
make %{?_smp_mflags}

%install

install -d %{buildroot}%{_sysconfdir}/colab/settings.d/

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

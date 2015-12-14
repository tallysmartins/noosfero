Summary: Collaboration platform for communities (Python dependencies)
Name:    colab-deps
Version: 1.12.2
Release: 1
Source0: colab-deps-%{version}.tar.gz
License: Various
Group: Development/Tools
BuildRoot: %{_tmppath}/colab-deps-%{version}-%{release}-buildroot
Prefix: %{_prefix}
Vendor: Sergio Oliveira <sergio@tracy.com.br>
Url: https://gitlab.com/softwarepublico/colab-deps
BuildRequires: gettext, libxml2-devel, libxslt-devel, openssl-devel, libffi-devel, libjpeg-turbo-devel, zlib-devel, freetype-devel, postgresql-devel, python-devel, libyaml-devel, python-virtualenv, libev-devel, gcc

%description
Integrated software development platform (Python dependencies).

%prep
%setup -q

%build
cd %{_builddir}
make

%install
cd %{_builddir}
%make_install

%clean
rm -rf $RPM_BUILD_ROOT

%files
/usr/lib/colab
%defattr(-,root,root)

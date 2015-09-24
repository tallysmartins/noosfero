%define name colab-deps
%define version 1.11.0
%define release 1

Summary: Collaboration platform for communities (Python dependencies)
Name: %{name}
Version: %{version}
Release: %{release}
Source0: %{name}-%{version}.tar.gz
License: Various
Group: Development/Tools
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
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

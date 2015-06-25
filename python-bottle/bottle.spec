%define name bottle
%define version 0.13_dev
%define unmangled_version 0.13-dev
%define unmangled_version 0.13-dev
%define release 1

Summary: Fast and simple WSGI-framework for small web-applications.
Name: %{name}
Version: %{version}
Release: %{release}
Source0: %{name}-%{unmangled_version}.tar.gz
License: MIT
Group: Development/Libraries
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Prefix: %{_prefix}
BuildArch: noarch
Vendor: Marcel Hellkamp <marc@gsites.de>
Url: http://bottlepy.org/
Requires: python >= 2.7
BuildRequires: python >= 2.7
BuildRequires: python-devel >= 2.7
BuildRequires: python-setuptools >= 0.9.8

%description

Bottle is a fast and simple micro-framework for small web applications. It
offers request dispatching (Routes) with url parameter support, templates,
a built-in HTTP Server and adapters for many third party WSGI/HTTP-server and
template engines - all in a single file and with no dependencies other than the
Python Standard Library.

Homepage and documentation: http://bottlepy.org/

Copyright (c) 2014, Marcel Hellkamp.
License: MIT (see LICENSE for details)


%prep
%setup -n %{name}-%{unmangled_version} -n %{name}-%{unmangled_version}

%build
python setup.py build

%install
python setup.py install --single-version-externally-managed -O1 --root=$RPM_BUILD_ROOT --record=INSTALLED_FILES

%clean
rm -rf $RPM_BUILD_ROOT

%files -f INSTALLED_FILES
%defattr(-,root,root)

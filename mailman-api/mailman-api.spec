%define name mailman-api
%define version 0.3c1
%define unmangled_version 0.3c1
%define release 1

Summary: REST API daemon to interact with Mailman 2
Name: %{name}
Version: %{version}
Release: %{release}
Source0: %{name}-%{unmangled_version}.tar.gz
License: LICENSE.txt
Group: Development/Libraries
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Prefix: %{_prefix}
BuildArch: noarch
Vendor: Sergio Oliveira <sergio@tracy.com.br>
Requires: mailman, python >= 2.7, python-paste >= 1.7.5.1, bottle >= 0.11.6
Url: http://pypi.python.org/pypi/mailman-api/

BuildRequires: python >= 2.7, python-devel >= 2.7, python-setuptools >= 0.9.8

%description
mailman-api
===========

`mailman-api` provides a daemon that will listen to HTTP requests,
providing access to a REST API that can be used to interact with a
locally-installed Mailman instance.

Documentation
--------------

Documentation available at: http://mailman-api.readthedocs.org/


Licensing information
---------------------

Copyright (C) 2013-2014 Sergio Oliveira

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

%{?systemd_requires}

%prep
%setup -n %{name}-%{unmangled_version} -n %{name}-%{unmangled_version}

%build
python setup.py build

%install
python setup.py install --single-version-externally-managed -O1 --root=$RPM_BUILD_ROOT --record=INSTALLED_FILES
mkdir -p $RPM_BUILD_ROOT%{_unitdir}
cp init/systemd/%{name}.service $RPM_BUILD_ROOT%{_unitdir}

%post
%service_add_post mailman-api.service

%preun
%systemd_preun mailman-api.service

%postun
%systemd_postun mailman-api.service

%clean
rm -rf $RPM_BUILD_ROOT

%files -f INSTALLED_FILES
%{_unitdir}/%{name}.service
%defattr(-,root,root)

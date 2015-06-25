%undefine _configure_target

Name: tango-icon-theme
Version: 0.8.90
Release: alt2

Summary: Tango Icon Library
License: Creative Commons Attribution Share-Alike license 2.5
Group: Graphical desktop/Other
Url: http://tango.freedesktop.org/Tango_Desktop_Project

Source0: http://tango-project.org/releases/%name-%version.tar.gz

BuildArch: noarch

BuildRequires: icon-naming-utils ImageMagick ImageMagick-devel perl-XML-Parser intltool

%description
This is an icon theme that follows the Tango visual guidelines.

%prep
%setup -q

%build
%configure
make

%install
%make_install DESTDIR=%buildroot install

%files
%doc AUTHORS COPYING ChangeLog README
%dir %_datadir/icons/Tango/
%_datadir/icons/Tango/

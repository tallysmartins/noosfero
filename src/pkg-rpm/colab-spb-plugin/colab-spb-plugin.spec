Name:           colab-spb-plugin
Version:        5.0a10
Release:        1
Summary:        SPB-specific Colab plugin
License:        GPL-3.0
Group:          Applications/Publishing
Url:            https://softwarepublico.gov.br/gitlab/softwarepublico/softwarepublico
Source0:        %{name}-%{version}.tar.gz
Requires:       colab >= 1.11
BuildArch:      noarch
BuildRequires:  colab, colab-deps >= 1.12.13, python-virtualenv

%description
This package contains Colab plugin for the Software Público Brasileiro platform.

%prep
%setup -q

%build
# install colab and colab-des into virtualenv
rm -rf virtualenv
cp -r /usr/lib/colab virtualenv
PATH=$(pwd)/virtualenv/bin:$PATH pip install --use-wheel --no-index .
virtualenv --relocatable virtualenv

rpm -ql colab-deps colab | sed '/^\/usr\/lib\/colab\// !d; s#/usr/lib/colab/##' > cleanup.list
while read f; do
  if [ -f "virtualenv/$f" ]; then
    rm -f "virtualenv/$f"
  fi
done < cleanup.list
rm -f cleanup.list
find virtualenv -type d -empty -delete
rm -rf virtualenv/bin
rm -rf virtualenv/include

%install

install -d -m 0755 %{buildroot}/usr/lib
rm -rf %{buildroot}/usr/lib/colab
cp -r virtualenv %{buildroot}/usr/lib/colab

%files
%defattr(-,root,root)
/usr/lib/colab

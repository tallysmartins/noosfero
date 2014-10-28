#!/bin/bash

# Copia os sources e os patches para o diretório de construção dos RPMS
mkdir -p ~/rpmbuild/SOURCES
cp sources/* ~/rpmbuild/SOURCES
cp patches/* ~/rpmbuild/SOURCES

# Copia os specs para o diretório de construção dos RPMS
mkdir -p ~/rpmbuild/SPECS
cp specs/* ~/rpmbuild/SPECS

# Cria os diretórios de construção
mkdir -p ~/rpmbuild/BUILD
mkdir -p ~/rpmbuild/BUILDROOT

# Cria os diretórios de output
mkdir -p ~/rpmbuild/RPMS
mkdir -p ~/rpmbuild/SRPMS

# Pacotes a serem construídos
PACKAGES=solr-4.6.1

for pkg in $PACKAGES; do
    echo "Spec found = $pkg.spec"
    rpmbuild -ba --define '__os_install_post    \
    /usr/lib/rpm/redhat/brp-compress \
    %{!?__debug_package:/usr/lib/rpm/redhat/brp-strip %{__strip}} \
    /usr/lib/rpm/redhat/brp-strip-static-archive %{__strip} \
    /usr/lib/rpm/redhat/brp-strip-comment-note %{__strip} %{__objdump} \
%{nil}'  ~/rpmbuild/SPECS/$pkg.spec
done

# Copia os pacotes gerados para o diretório packages
find ../rpmbuild/RPMS -name '*.rpm' -exec cp {} packages/ \;
find ../rpmbuild/SRPMS -name '*.rpm' -exec cp {} packages/ \;

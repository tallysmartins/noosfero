#
# Spec file do solr
#

# Preamble

Summary: Solr is the search platform from Apache Lucene project.
Name: solr
Version: 4.6.1

License: Apache License, Version 2.0
Group: Applications/Internet
Source:	http://archive.apache.org/dist/lucene/solr/4.6.1/solr-4.6.1.tgz
Patch: solr-4.6.1.patch
URL: http://lucene.apache.org/solr/
Vendor: The Apache Software Foundation
Requires: java

%description
SolrTM is the popular, blazing fast open source enterprise search platform from the Apache LuceneTM project. Its major features include powerful full-text search, hit highlighting, faceted search, near real-time indexing, dynamic clustering, database integration, rich document (e.g., Word, PDF) handling, and geospatial search. Solr is highly reliable, scalable and fault tolerant, providing distributed indexing, replication and load-balanced querying, automated failover and recovery, centralized configuration and more. Solr powers the search and navigation features of many of the world's largest internet sites.

# Esta seção prepara o ambiente para a construção do pacote. Pode ser
# entendida como um shell script, e é o local onde podem ser aplicados
# os patches
%prep

# A macro %setup prepara o ambiente, de forma semelhante aos comandos abaixo:
#   rm -rf $RPM_BUILD_DIR/cdp-0.33
#   zcat $RPM_SOURCE_DIR/cdp-0.33.tar.gz | tar vxf -
%setup
%patch -p 1

# Esta é a seção responsável pela construção do software. Também é um
# shell script, e não tem macros associadas
%build

# Seção responsável pela instalação do software. Também é um shell script
%install
mkdir -p %{buildroot}/usr/share/solr
cp -r %{_builddir}/solr-4.6.1/* %{buildroot}/usr/share/solr

mkdir -p %{buildroot}/usr/share/solr/example/solr
cp -r %{_builddir}/solr-4.6.1/example/webapps/solr.war %{buildroot}/usr/share/solr/example/solr/

mkdir -p %{buildroot}/etc/init.d
cp -r %{_builddir}/solr-4.6.1/scripts/solr %{buildroot}/etc/init.d/

# Esta seção lista todos os arquivos que fazem parte do pacote: se um
# arquivo não for listado abaixo, não será inserido no pacote. A diretiva
# %doc indica um arquivo de documentação
%files
/usr/share/solr
%attr(755, -, -) /etc/init.d/solr

%post
chmod u+x /usr/share/solr/start.sh
chkconfig solr on
service solr start

# Esta seção remove os arquivos que foram criados durante o build
%clean
rm -rf %{buildroot}


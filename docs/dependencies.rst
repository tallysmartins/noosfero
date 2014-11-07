
.. _dependencies:

Dependências
============

O repositório do SPB contém os pacotes que não são nativos do Sistema
Operacional onde o mesmo o sistema do Portal do Software Público deve ser
instalado. Esse repositório contém os pacotes referentes ao Bottle, Mailman-api,
Solr, Colab e às dependências do Colab (pacote Colab-deps).

Colab
----------
Esse pacote, contém o sistema Colab. O processo de
criação desse pacote depende do pacote `python-virtualenv`, além de um
conjunto de dependências python, contidos no pacote `colab-deps`, descrito na
próxima seção. O processo de instalação desse pacote requer uma instalação
prévia do pacote `colab-deps`, que é instalado automaticamente se o repositório
do mesmo estiver disponível no conjunto de repositórios do `yum`.

Colab-deps
----------
Este pacote contém as dependências *python* do Colab. Tais dependências foram
encapsuladas em um ambiente virtual python (`python-virtualenv`), permitindo uma
maior independência e, consequentemente, compatibilidade com o Sistema
Operacional no qual o pacote seja instalado. Esse pacote é composto pelas
ferramentas listadas a seguir.

* Chardet
* Django
* Django-browserid
* Django-cliauth
* Django-common
* Django-conversejs
* Django-haystack
* Django-hitcounter
* Django-i18n-model
* Django-mobile
* Django-mptt
* Django-piston
* Django-revproxy
* Django-taggit
* Django-tastypie
* Dpaste
* Etiquetando
* Eventlet
* Fancy_tag
* Feedzilla
* Grab
* Gunicorn
* Html2text
* Lorem-ipsum-generator
* Lxml
* Paste
* Pip
* Poster
* Psycopg2
* Pure-sasl
* Pygments
* Pysolr
* Python-dateutil
* Python-memcached
* Python-mimeparse
* PyYAML
* Raven
* Repoze.lru
* Requests
* Setuptools
* Six
* Sleekxmpp
* South
* Stemming
* Tornado
* Transliterate


Mailman-api
-----------

Esse pacote contém o Mailman-api. Esta ferramenta python possui como
dependência os pacotes Bottle e python. Como o Bottle não é provido
nativamente pelo CentOS 7, foi necessário empacotá-lo separadamente.

Bottle
-----------

Esse pacote contém a ferramenta Bottle, um framowork web escrito em
python, e requisito para a utilização da ferramenta Mailman-api. Este pacote
possui como dependência o pacote python, que está disponível nativamente no
CentOS.

Solr
----
Esse pacote contém a ferramenta python Bottle, e integra o conjunto de
ferramentas do SPB. Sua instalação requer o pacote Java, que já existe
nativamente no CentOS.

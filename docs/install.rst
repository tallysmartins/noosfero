Instalação
==========

.. Descrição dos pacotes e listagem das dependências de cada pacote

Para instalação das ferramentas que compõem o Software Público, é necessária a
instalação de um conjunto de pacotes RPM. Um pacote RPM consiste em uma coleção
de uma ou mais ferramentas que permite um meio automático de instalação,
atualização, configuração e remoção de softwares. 

O processo de instalação aqui descrito permite a instalação e configuração
desses pacotes em uma máquina com o Sistema Operacional CentOS 7 instalado e
atualizado. Os pacotes a seguir já são fornecidos nativamente pelo Sistema
Operacional, não sendo necessária uma configuração adicional para a
instalação dos mesmos.

* Mailman
* Nginx
* PostgreSQL Server

Somados a esses, alguns pacotes não fornecidos nativamente também são
necessários. Os mesmos estão listados a seguir.

* Noosfero
* Gitlab
* Solr
* Colab
* Colab-deps
* Mailman-api

Para disponibilizar cada pacote não nativo do CentOS 7, fez-se um levantamento
das dependências de cada ferramenta empacotada, bem como do processo de 
instalação de cada uma, de modo a automatizar esse processo.
A seção :ref:`dependencies` descreve brevemente o levantamento de dependências
feito.


Repositório do SPB
-------------------
.. Configuração do repositório yum em /etc/yum.repos.d

Para instalação dos pacotes existentes no repositório do SPB através do
gerenciador de instalação e remoção de pacotes do CentOS (o *Yum*), é preciso
adicionar o arquivo de configuração desse repositório no diretório
`/etc/yum.repos./` do Sistema Operacional onde o Portal do Software Público deve
ser instalado.

Procedimento:

Os comandos a seguir devem ser executados via terminal, com permissões de super
usuário do sistema.

1. Instalar (caso não esteja instalado) o programa `wget`, para download das
   configurações de repositório

::

   yum install -y wget

#. Ir para o diretório `/etc/yum.repos./`

::

   cd /etc/yum.repos./

#. Fazer o *download* dos arquivos de configuração nesse diretório:

::

   wget http://download.opensuse.org/repositories/isv:/spb:/colab/CentOS_7/isv:spb:colab.repo
   wget http://download.opensuse.org/repositories/isv:/spb:/mailman-api/CentOS_7/isv:spb:mailman-api.repo


Instalação das Ferramentas (via pacote)
---------------------------------------

.. Instalação dos pacotes via yum




Configurações
--------------


Nginx
+++++

Para configurar o Nginx crie o arquivo ``/etc/nginx/sites-enabled/colab.conf`` com o conteúdo abaixo: 

.. code-block:: nginx

   upstream colab {
     server                127.0.0.1:8001  fail_timeout=10s;
   }

   server {
     listen                *:80;

     server_name           beta.softwarepublico.gov.br;
     return                301 https://$server_name$request_uri;
   }

   server {
     listen                *:443 ssl;

     server_name           beta.softwarepublico.gov.br;

     ssl on;

     ssl_certificate           /etc/nginx/colab.crt;
     ssl_certificate_key       /etc/nginx/colab.key;
     ssl_session_cache         shared:SSL:10m;
     ssl_session_timeout       5m;
     ssl_protocols             SSLv3 TLSv1 TLSv1.1 TLSv1.2;
     ssl_ciphers               HIGH:!aNULL:!MD5;
     ssl_prefer_server_ciphers on;

     access_log            /var/log/nginx/ssl-colab.access.log;
     error_log             /var/log/nginx/ssl-colab.error.log;

     location /gitlab/assets/ {
       alias  /opt/gitlab/embedded/service/gitlab-rails/public/assets/;
     }

     location / {
       root  /usr/share/nginx/colab;
       try_files $uri @colab-app;
     }

     location @colab-app {
       proxy_pass              http://colab;
       proxy_read_timeout      90;
       proxy_connect_timeout   90;
       proxy_redirect          off;
       proxy_set_header        Host $host;
       proxy_set_header        X-Real-IP $remote_addr;
       proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header        X-Forwarded-Proto https;
     }
   }


Substitua o domínio de exemplo ``beta.softwarepublico.gov.br`` pelo domínio desejado.

Certifique-se de instalar o certificado SSL (``/etc/nginx/colab.crt``) e sua chave privada (``/etc/nginx/colab.crt``).

Reinicie o serviço do Nginx com o comando: ``sudo service nginx restart``.


Colab
+++++


Gitlab
++++++


Noosfero
++++++++



Mailman
+++++++

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
Procedimento:

Os comandos a seguir devem ser executados via terminal, com permissões de super
usuário do sistema.

1. Instalar (caso não esteja instalado) o programa `wget`, para download das
   configurações de repositório

::

   yum install -y wget

2. Ir para o diretório `/etc/yum.repos./`

::

   cd /etc/yum.repos./

3. Fazer o *download* dos arquivos de configuração nesse diretório:

::

   wget http://download.opensuse.org/repositories/isv:/spb:/colab/CentOS_7/isv:spb:colab.repo
   wget http://download.opensuse.org/repositories/isv:/spb:/mailman-api/CentOS_7/isv:spb:mailman-api.repo


Instalação das Ferramentas (via pacote)
---------------------------------------

.. Instalação dos pacotes via yum

Após a configuração do repositório do SPB, todos os pacotes deverão estar
disponíveis através do *yum*. Ainda que algumas dependências sejam tratadas
automaticamente, o comportamento de alguns pacotes é dependente da ordem em que
os mesmos são instalados. Portanto, deve-se executar a instalação na ordem
especificada a seguir.
Os comandos a seguir devem ser executados via terminal, com permissões de super
usuário do sistema.

Procedimento:

1. Instalar o pacote PostreSQL Server

::

   yum install postgresql-server

2. Instalar os pacotes do Colab, Noosfero e Gitlab

::

   yum install colab noosfero gitlab

3. Instalar os pacotes Nginx

::

   yum install nginx

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

Crie/edite o arquivo ``/etc/colab/settings.d/admins.yaml`` e adicione o nome e e-mail dos administradores do sistema:

.. code-block:: yaml

   ## System admins
   ADMINS: &admin
     -
       - John Foo
       - john@example.com
	 -
	   - Mary Bar
	   - mary@example.com

   MANAGERS: *admin


Crie/edite o arquivo ``/etc/colab/settings.d/hosts.yaml`` e configure a URL principal da aplicação, quais hosts deverão aceitar requisições e quais hosts poderão ser utilizadas para que o login seja efetuado. Exemplo:

.. code-block:: yaml

   SITE_URL: 'https://beta.softwarepublico.gov.br'

   ALLOWED_HOSTS:
     - beta.softwarepublico.gov.br

   BROWSERID_AUDIENCES:
     - http://beta.softwarepublico.gov.br
     - https://beta.softwarepublico.gov.br


Crie/edite o arquivo ``/etc/colab/settings.d/email.yaml`` e configure o endereço que será utilizado no FROM dos e-mails enviados pelo Colab. Veja o exemplo:

.. code-block:: yaml

   COLAB_FROM_ADDRESS: '"Portal do Software Publico" <noreply@beta.softwarepublico.gov.br>'
   SERVER_EMAIL: '"Portal do Software Publico" <noreply@beta.softwarepublico.gov.br>'


Crie/edite o arquivo ``/etc/colab/settings.d/conversejs.yaml`` e desative o Converse.js:

.. code-block:: yaml

   CONVERSEJS_ENABLED: False


Crie/edite o arquivo ``/etc/colab/settings.d/feedzilla.yaml`` e desative o Feedzilla (blog planet):

.. code-block:: yaml

   FEEDZILLA_ENABLED: False


*(opcional)* Crie/edite o arquivo ``/etc/colab/settings.d/raven.yaml`` e adicione a *string* de conexão da sua instancia do Sentry  como no exemplo abaixo:

.. code-block:: yaml

   ### Log errors to Sentry instance
   RAVEN_DSN: 'https://<user>:<key>@sentry.example.com/<id>'


Após editar todos os arquivos desejados reinicie o processo do Colab com utilizando o comando ``service colab restart``.


Gitlab
++++++

Crie/edite o arquivo ``/etc/gitlab/gitlab.rb`` com o seguinte conteúdo:

.. code-block:: ruby

   external_url 'https://beta.softwarepublico.gov.br'
   gitlab_rails['internal_api_url'] = 'http://127.0.0.1:8090/gitlab'
   nginx['enable'] = false
   unicorn['enable'] = true
   unicorn['port'] = 8090
   postgresql['port'] = 5433
   gitlab_rails['gitlab_https'] = true
   gitlab_rails['env_enable'] = true
   gitlab_rails['env_database_name'] = 'colab'
   gitlab_rails['env_database_host'] = '127.0.0.1'
   gitlab_rails['env_database_user'] = '<usuario_do_postgresql>'
   gitlab_rails['env_database_password'] = '<senha_do_postgresql>'
   gitlab_rails['omniauth_enabled'] = true
   gitlab_rails['omniauth_allow_single_sign_on'] = true
   gitlab_rails['omniauth_block_auto_created_users'] = false


Substitua o domínio ``beta.softwarepublico.gov.br`` pelo desejado, e configure o usuário e senha que terão acesso ao banco de dados.

Execute o comando para regerar a configuração do Gitlab: ``gitlab-ctl reconfigure``. Ao termino da reconfiguração o script irá reiniciar o serviço automaticamente.


Noosfero
++++++++

Edite o arquivo ``/etc/noosfero/thin.yml``, e adicione uma linha com o
seguinte conteúdo:

.. code-block:: yaml

   prefix: /social

Crie/edite o arquivo ``/etc/default/noosfero`` e adicione a seguinte
linha:

.. code-block:: sh

   export RAILS_RELATIVE_URL_ROOT=/social

Reinicie o serviço:

.. code-block:: sh

   $ sudo service noosfero restart

Mailman
+++++++

Edite o arquivo de configuração do `mailman` em
``/etc/mailman/mm_cfg.py``, e ajuste os seguintes valores:

.. code-block:: python

   DEFAULT_EMAIL_HOST = 'listas.softwarepublico.gov.br'
   MTA = None
   POSTFIX_STYLE_VIRTUAL_DOMAINS ['listas.softwarepublico.gov.br']

Crie a lista de discussão default, necessária para a inicialização do
serviço. Substitua ``USER@DOMAIN.COM`` pelo email a ser usado como
administrador do `mailman`, e ``PASSWORD`` pela senha de administração do
`mailman`.

.. code-block:: sh

   $ sudo -u mailman newlist --quiet mailman USER@DOMAIN.COM PASSWORD
   $ sudo service mailman restart


Configure o postfix:

.. code-block:: sh

   $ sudo postconf relay_domains=listas.softwarepublico.gov.br
   $ sudo postconf transport_maps=hash:/etc/postfix/transport

Crie/edite ``/etc/postfix/transport`` com o seguinte conteúdo::

   listas.softwarepublico.gov.br mailman:

Gere o banco de dados para consulta, e reinicie o serviço::

.. code-block:: sh

   $ sudo postmap /etc/postfix/transport
   $ sudo service postfix restart

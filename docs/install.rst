Instalação
==========

(see :ref:`dependencies`)


Repositório do SPB
-------------------



Instalação das Ferramentas (via pacote)
---------------------------------------



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

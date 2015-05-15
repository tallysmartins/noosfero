Gestão do Firewall
==================

Firewall Interno
-----------------

O Portal do Software Público atualmente é composto por diversos serviços funcionando em diferentes servidores. Para o seu correto funcionamento é esperado que estes serviços se comuniquem através de TCP/IP. 

Os scripts de instalação do Portal do Software Público também cuidam da manutenção das regras de firewall. Cada máquina possui um firewall (iptables) local que por padrão nega todos os tipos de conexão de entrada em todas as portas (INPUT rules) mas permite conexões de saída (OUTPUT rules).

Todas as regras de firewall são definidas no cookbook ``firewall``. Para definir regras de comunidacação entre hosts locais, válidas para todos os ambientes (local, produção, homologação, testes, etc) são utilizados templates que podem ser encontrados em ``cookbooks/firewall/templates/``. Para regras de filtro utilize o arquivo ``iptables-filter.erb`` e para regras de nat o arquivo ``iptables-nat.erb``. 

Para adicionar regras específicas de cada ambiente (por exemplo, abrir uma porta diferente em homologação) utilize o arquivo ``config/<nome_do_ambiente>/iptables-filter-rules``. Este arquivo aceita apenas regras de filtro do tipo INPUT.


Comunicação Entre Serviços
++++++++++++++++++++++++++++

Os serviços que compõe o portal e suas portas de entrada são descritos na tabela a seguir:

+--------------+--------------+---------------+--------+
| Destino      | Origem       + Serviço       | Porta  |
+==============+==============+===============+========+
| database     | integration  | Redis         | 6379   |
+--------------+--------------+---------------+--------+
| database     | integration  | PostgreSQL    | 5432   |
+--------------+--------------+---------------+--------+
| database     | social       | PostgreSQL    | 5432   |
+--------------+--------------+---------------+--------+
| social       | reverseproxy | Nginx         | 80     |
+--------------+--------------+---------------+--------+
| social       | reverseproxy | Nginx         | 443    |
+--------------+--------------+---------------+--------+
| integration  | reverseproxy | Nginx         | 80     |
+--------------+--------------+---------------+--------+
| integration  | reverseproxy | Nginx         | 443    |
+--------------+--------------+---------------+--------+
| email        | externa      | Postfix       | 25     |
+--------------+--------------+---------------+--------+
| reverseproxy | externa      | Nginx         | 80     |
+--------------+--------------+---------------+--------+
| reverseproxy | externa      | Nginx         | 443    |
+--------------+--------------+---------------+--------+
| reverseproxy | externa      | OpenSSH (git) | 22     |
+--------------+--------------+---------------+--------+


Comunicação externa
-------------------

+--------------+---------------+--------+
| Destino      | Serviço       | Porta  |
+==============+===============+========+
| email        | Postfix       | 25     |
+--------------+---------------+--------+
| reverseproxy | Nginx         | 80     |
+--------------+---------------+--------+
| reverseproxy | Nginx         | 443    |
+--------------+---------------+--------+
| reverseproxy | OpenSSH (git) | 22     |
+--------------+---------------+--------+

**Outros firewalls da rede:**

Além do firewall local é importante que os serviços com origem ``externa`` tenham suas portas de INPUT abertas em todos os firewalls da rede. No caso do host ``email`` a porta **25** também deve estar aberta para OUTPUT (alternativamente o Postfix pode ser configurado para enviar e-mails utilizando um relay interno).

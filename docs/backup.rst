Backup
======

O Portal do Software Público possui scripts para a automatização tanto de backup quanto de restore dos dados. A função backup copia todos os dados do Noosfero, GitLab, Colab e Mailman, enviando-os para a pasta backups, da máquina que executou o script. Para executar a função de backup:

rake backup SPB_ENV=from_environment

A função restore utiliza os dados gerados no backup para restaurar as informações das ferramentas do Portal do Software Publico no servidor destino. Para executar o restore:

rake restore SPB_ENV=to_environment

PSB Theme for Noosfero
================================

Noosfero theme for the _Portal do Software Público_ project.

Install on /public/designs/themes/noosfero-spb-theme

================================

# Passos para configurar o tema a partir do spb/spb

## Considerando que o clone do noosfero está na pasta home

```bash
rm -r ~/noosfero/public/design/theme/noosfero-spb-theme
cd ~
git clone git@softwarepublico.gov.br:softwarepublico/softwarepublico.git
cd softwarepublico/src/noosfero-spb/
ln -sr noosfero-spb-theme/ ~/noosfero/public/designs/themes/
ln -sr software_communities ~/noosfero/plugins/
ln -sr gov_user ~/noosfero/plugins/
git remote add theme git@softwarepublico.gov.br:softwarepublico/noosfero-spb-theme.git
```

# Para instalar o Colab

```bash
cd ~
git clone https://github.com/colab/colab
```

## Configuração

Seguir [tutorial](https://github.com/colab/colab/blob/master/README.rst) do próprio Colab

## Arquivos de configuração Colab

Estando com o ambiente do vagrant levantado `(vagrant up && vagrant ssh)`,
e "trabalhando" com o colab `(workon colab)`:

## Clone os repositórios:

```bash
cd ~
git clone git@softwarepublico.gov.br:softwarepublico/softwarepublico.git
git clone https://github.com/colab/colab-gitlab-plugin
git clone https://github.com/colab/colab-noosfero-plugin
```

## Criando diretórios - Plugins do Colab

```bash
mkdir /etc/colab/plugins.d/
cd plugins.d
```

## Crie os arquivos

### gitlab.py

```bash
vim gitlab.py
```

#### Conteúdo do gitlab.py

```python
from django.utils.translation import ugettext_lazy as _
from colab.plugins.utils.menu import colab_url_factory

name = "colab_gitlab"
verbose_name = "Gitlab"

upstream = ''
private_token = ''

urls = {
         "include":"colab_gitlab.urls",
         "prefix": 'gitlab/',
         "namespace":"gitlab"
       }

url = colab_url_factory('gitlab')
```

### noosfero.py

```bash
vim noosfero.py
```

#### Conteúdo do noosfero.py

```python
from django.utils.translation import ugettext_lazy as _
from colab.plugins.utils.menu import colab_url_factory

name = "colab_noosfero"
verbose_name = "Noosfero"
private_token = ""

upstream = 'http://<IP DA SUA MÁQUINA AQUI>:8080/social'

urls = {
         "include":"colab_noosfero.urls",
         "prefix": '^social/',
         "namespace":"social"
       }

url = colab_url_factory('social')
```

### spb.py

```bash
vim spb.py
```

#### Conteúdo do spb.py

```python
from django.utils.translation import ugettext_lazy as _
from colab.plugins.utils.menu import colab_url_factory

name = "colab_spb"
verbose_name = "SPB Plugin"
urls = {
         "include":"colab_spb.urls",
         "prefix": '^spb/',
         "namespace":"colab_spb"
       }

url = colab_url_factory('colab_spb')
```
### Execuntando scripts de instalação

```bash
cd ~/softwarepublico/config/
pip install -e .
cd ~/softwarepublico/src/colab-spb-plugin/
pip install -e .
colab-admin migrate
colab-admin migrate colab_spb
cd ~/colab-gitlab-plugin/
pip install -e .
cd ~/softwarepublico/src/colab-spb-plugin/
pip install -e .
colab-admin migrate
```

## Finalizando

Execute o noosfero seja no ambiente local, ou schroot,
com o comando `RAILS_RELATIVE_URL_ROOT=/social unicorn`

No vagrant, execute `colab-admin runserver 0.0.0.0:8000`

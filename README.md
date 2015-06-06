# Colab SPB theme

Tema para o Colab relacionado ao projeto SPB (Software Público Brasileiro).

## Testando Colab SPB theme

### Requisitos para testar o tema no ambiente do Colab

* virtualbox
* vagrant

### Passo-a-passo

1. Clonar o repositório do Colab (https://beta.softwarepublico.gov.br/gitlab/softwarepublico/colab)

2. Entre na raiz do repositório do Colab (cd colab)

3. Crie o diretório "theme" e entre no mesmo (mkdir theme; cd theme)

4. Clonar o repositório colab-spb-theme (https://beta.softwarepublico.gov.br/gitlab/softwarepublico/colab-spb-theme)

5. Volte para a raíz do repositório do Colab e edite o arquivo initconfig.py (cd .. ; vim colab/management/initconfig.py)

Adicione o seguinte conteúdo ao final do arquivo:

```python
CONFIG_TEMPLATE += """
COLAB_STATICS = ['/vagrant/theme/colab-spb-theme/static']
COLAB_TEMPLATES = ('/vagrant/theme/colab-spb-theme/templates',)
"""
```

6. Subir a máquina virtual do Colab, utilizar chef/centos-7.0 quando for solicitado (vagrant up)

7. Logue na máquina virtual (vagrant ssh)

8. Entre no diretório /vagrant (cd /vagrant)

9. Logue no virtualenv do Colab (workon colab)

10. Execute o servidor de desenvolvimento do Colab (colab-admin runserver 0.0.0.0:8000)

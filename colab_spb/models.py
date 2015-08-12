from colab.super_archives import models as mailman
from django.conf import settings
from django.db import models
import importlib
from sys import modules

# Create your models here.
# Import plugins models
for app in settings.COLAB_APPS:
    if app != 'colab_spb':
        plugin_name = app.split('.')[-1]
        # Create alias to plugins
        exec "%s = importlib.import_module('%s.models')" % (plugin_name, app)


class CommunityAssociations(models.Model):
    community = models.ForeignKey(noosfero.NoosferoCommunity) \
        if 'noosfero' in modules else None

    repository = models.ForeignKey(gitlab.GitlabProject) \
        if 'gitlab' in modules else None

    mail_list = models.ForeignKey(mailman.MailingList, null=True)

from colab_gitlab import models as gitlab
from colab_noosfero import models as noosfero
from colab.super_archives import models as mailman
from django.db import models


class CommunityAssociations(models.Model):
    community = models.ForeignKey(noosfero.NoosferoCommunity, null=True)
    group = models.ForeignKey(gitlab.GitlabGroup, null=True)
    mail_list = models.ForeignKey(mailman.MailingList, null=True)

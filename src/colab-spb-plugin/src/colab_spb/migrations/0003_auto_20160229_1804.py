# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    def associate_communities_groups(apps, schema_editor):
        GitlabGroup = models.get_model("colab_gitlab", "GitlabGroup")
        NoosferoCommunity = models.get_model("colab_noosfero",
                                             "NoosferoCommunity")
        CommunityAssociations = models.get_model("colab_spb",
                                                 "CommunityAssociations")

        for community_association in CommunityAssociations.objects.all():
            try:
                community = community_association.community
                group = GitlabGroup.objects.get(name__iexact=community.name)
                community_association.group = group
                community_association.save()
            except GitlabGroup.DoesNotExist:
                continue


    dependencies = [
        ('colab_spb', '0002_auto_20160229_1735'),
    ]

    operations = [
        migrations.RunPython(associate_communities_groups)
    ]

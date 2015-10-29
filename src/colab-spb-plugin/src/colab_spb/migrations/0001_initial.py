# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('colab_gitlab', '0001_initial'),
        ('colab_noosfero', '__first__'),
        ('super_archives', '0002_mailinglist_is_private'),
    ]

    operations = [
        migrations.CreateModel(
            name='CommunityAssociations',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('community', models.ForeignKey(to='colab_noosfero.NoosferoCommunity', null=True)),
                ('group', models.ForeignKey(to='colab_gitlab.GitlabGroup', null=True)),
                ('mail_list', models.ForeignKey(to='super_archives.MailingList', null=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]

from django.conf.urls import patterns, url
from . import views

urlpatterns = patterns('',
                       url(r'^mail_list/$', views.mail_list, name='mail_list'),
                       url(r'^gitlab_activity/$', views.gitlab_activity,
                           name='gitlab_activity'),)

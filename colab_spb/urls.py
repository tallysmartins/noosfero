from django.conf.urls import patterns, url
from . import views

urlpatterns = patterns('',
    url( r'^get_list/$',views.get_list, name='get_list'),
)

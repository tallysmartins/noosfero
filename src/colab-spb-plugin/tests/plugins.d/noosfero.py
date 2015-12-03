
from django.utils.translation import ugettext_lazy as _
from colab.plugins.utils.menu import colab_url_factory

# Noosfero plugin - Put this in plugins.d/noosfero.py to actiate ##
# from django.utils.translation import ugettext_lazy as _
# from colab.plugins.utils.menu import colab_url_factory

name = 'colab_noosfero'
verbose_name = 'Noosfero Plugin'

upstream = 'localhost'
# middlewares = []

urls = {
    'include': 'colab_noosfero.urls',
    'prefix': 'social',
}

menu_title = _('Social')

url = colab_url_factory('noosfero')

menu_urls = (
    url(display=_('Users'), viewname='noosfero',
        kwargs={'path': '/search/people'}, auth=False),
    url(display=_('Communities'), viewname='noosfero',
        kwargs={'path': '/search/communities'}, auth=False),
    url(display=_('Profile'), viewname='noosfero',
        kwargs={'path': '/profile/~/'}, auth=True),
    url(display=_('Control Panel'), viewname='noosfero',
        kwargs={'path': '/myprofile/~/'}, auth=True),

)

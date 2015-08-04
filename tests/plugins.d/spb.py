from colab.plugins.utils.menu import colab_url_factory

name = 'colab_spb'
verbose_name = 'Spb plugin'

urls = {
    'include': 'colab_spb.urls',
    'namespace': 'spb',
    'prefix': 'spb',
}

url = colab_url_factory("spb")

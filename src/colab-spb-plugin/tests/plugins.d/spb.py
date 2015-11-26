from colab.plugins.utils.menu import colab_url_factory

name = "colab_spb"
verbose_name = "SPB Plugin"

middlewares = ['colab_spb.middleware.ForceLangMiddleware']

urls = {"include": "colab_spb.urls",
        "prefix": '^spb/',}

url = colab_url_factory('colab_spb')

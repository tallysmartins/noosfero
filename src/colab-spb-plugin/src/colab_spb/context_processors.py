from django.conf import settings


def sisp_url(request):
    return {'SISP_URL': getattr(settings, 'SISP_URL', False)}

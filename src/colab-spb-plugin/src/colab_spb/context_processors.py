from django.conf import settings


def multiportal_url(request):
    return {'SISP_HOST': getattr(settings, 'SISP_HOST', False),
            'SPB_HOST': getattr(settings, 'SPB_HOST', False),}

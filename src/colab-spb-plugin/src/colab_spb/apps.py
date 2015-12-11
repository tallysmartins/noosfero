from django.apps import AppConfig
from colab.signals.signals import connect_signal, register_signal
from celery.utils.log import get_task_logger
from colab_spb.tasks import community_creation, community_updated

logger = get_task_logger(__name__)


class SpbAppConfig(AppConfig):
    name = 'colab_spb'
    verbose_name = 'SPB'
    short_name = 'spb'
    namespace = 'spb'

    signals_list = ['create_repo', 'create_mail_list']

    def register_signal(self):
        logger.info('Signals from {0} registed '.format(self.short_name))
        register_signal(self.short_name, self.signals_list)

    def connect_signal(self):
        connect_signal('community_creation', 'noosfero', community_creation)
        connect_signal('community_updated', 'noosfero', community_updated)

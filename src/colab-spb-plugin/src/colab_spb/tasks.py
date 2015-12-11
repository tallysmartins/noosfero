import requests

from django.conf import settings

from colab.celery import app
from colab.signals.signals import send
from celery.utils.log import get_task_logger
from colab_gitlab.models import GitlabGroup

logger = get_task_logger(__name__)


def create_group_from_community(noosfero_community):
    """ Create a group into Gitlab  from a Noosfero's Community"""

    # If project already exist
    group = GitlabGroup.objects.filter(name=noosfero_community.name)
    if group:
        return group[0].id

    app_config = settings.COLAB_APPS.get('colab_gitlab', {})
    private_token = app_config.get('private_token')
    upstream = app_config.get('upstream', '').rstrip('/')
    verify_ssl = app_config.get('verify_ssl', False)

    error_msg = u'Error trying to create group "%s" on Gitlab. Reason: %s'

    users_endpoint = '{}/api/v3/groups'.format(upstream)

    params = {
        'name': noosfero_community.name,
        'path': noosfero_community.identifier,
        'private_token': private_token
    }
    group_id = None
    try:
        response = requests.post(users_endpoint, params=params,
                                 verify=verify_ssl)
    except Exception as excpt:
        reason = 'Request to API failed ({})'.format(excpt)
        logger.error(error_msg, noosfero_community.name, reason)
        return

    if response.status_code != 201:
        if response.status_code is 404:
            pass  # TODO: should request the existing group id if error 404
        reason = 'Unknown [{}].'.format(response.status_code)
        logger.error(error_msg, noosfero_community.name, reason)
        return
    else:
        group_id = response.json().get('id')
        logger.info('Group {0} created'.format(noosfero_community.name))

    return group_id


def include_members_into_group(admins, group_id):
    """ Include members from a Noosfero's Community into a  Gitlab's group """

    app_config = settings.COLAB_APPS.get('colab_gitlab', {})
    private_token = app_config.get('private_token')
    upstream = app_config.get('upstream', '').rstrip('/')
    verify_ssl = app_config.get('verify_ssl', False)
    error_msg = u'Error to include "%s" to create group "%s" on Gitlab. \
    Reason: %s'

    user_id = None
    users_endpoint = '{}/api/v3/users'.format(upstream)
    for admin in admins:
        params = {'search': admin.username,
                  'private_token': private_token}
        response = requests.get(users_endpoint, params=params,
                                verify=verify_ssl)
        users = response.json()
        # Be sure to get only one
        for user in users:
            if user['username'] == admin.username:
                user_id = user['id']
                break

        users_endpoint = '{}/api/v3/groups/{}/members'.format(
            upstream, group_id)
        params = {
            'user_id': user_id,
            'access_level': 50,  # OWNER = 50
            'private_token': private_token
        }
        try:
            response = requests.post(users_endpoint, params=params,
                                     verify=verify_ssl)
        except Exception as excpt:
            reason = 'Request to API failed ({})'.format(excpt)
            logger.error(error_msg, admin.username, reason)
            return
        logger.info('Members included')


def create_project(project_name, group_id):
    """ Create a project into Gitlab group """
    app_config = settings.COLAB_APPS.get('colab_gitlab', {})
    private_token = app_config.get('private_token')
    upstream = app_config.get('upstream', '').rstrip('/')
    verify_ssl = app_config.get('verify_ssl', False)
    error_msg = u'Error to create project "%s" into Gitlab. Reason: %s'

    users_endpoint = '{}/api/v3/projects'.format(upstream)
    params = {
        'name': project_name,
        'public': True,
        'visibility_level': 20,  # show to all
        'namespace_id': group_id,
        'private_token': private_token
    }
    try:
        requests.post(users_endpoint, params=params,
                      verify=verify_ssl)
    except Exception as excpt:
        reason = 'Request to API failed ({})'.format(excpt)
        logger.error(error_msg, project_name, reason)
        return
    logger.info('Project created')


@app.task(bind=True)
def community_creation(self, **kwargs):
    f = open('/vagrant/community_creation', 'wb')
    f.write(str(kwargs))
    f.close()
    logger.info('Community created: {0}'.format(''.join(kwargs)))

    send('create_repo', 'spb')
    send('create_mail_list', 'spb')

    noosfero_community = kwargs['community']
    admins = noosfero_community.admins.all()

    group_id = create_group_from_community(noosfero_community)
    include_members_into_group(admins, group_id)
    create_project(noosfero_community.name, group_id)

    return 6


@app.task(bind=True)
def community_updated(self, **kwargs):
    f = open('/vagrant/community_updated', 'wb')
    f.write(str(kwargs))
    f.close()
    logger.info('Community updated: {0}'.format(''.join(kwargs)))
    return 7

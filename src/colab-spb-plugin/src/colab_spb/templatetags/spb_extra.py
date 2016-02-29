from django import template

from colab_spb.models import CommunityAssociations

register = template.Library()

@register.simple_tag
def get_community(mailinglist):
    ml = mailinglist
    community = ""

    try:
        community_association = CommunityAssociations.objects.get(mail_list=ml)
        community = community_association.community.name
    except CommunityAssociations.DoesNotExist:
        community = "software"

    return community

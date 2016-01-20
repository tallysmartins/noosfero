from colab.widgets.widget_manager import WidgetManager
from colab.accounts.widgets.group import GroupWidget
from colab.accounts.widgets.group_membership import GroupMembershipWidget
from colab.accounts.widgets.latest_posted import LatestPostedWidget
from colab.accounts.widgets.latest_contributions import \
    LatestContributionsWidget

from colab.accounts.widgets.collaboration_chart import CollaborationChart
from colab.accounts.widgets.participation_chart import ParticipationChart

# Profile Widgets
WidgetManager.register_widget('group', GroupWidget())
WidgetManager.register_widget('button', GroupMembershipWidget())
WidgetManager.register_widget('list', LatestPostedWidget())
WidgetManager.register_widget('list', LatestContributionsWidget())
WidgetManager.register_widget('charts', CollaborationChart())
WidgetManager.register_widget('charts', ParticipationChart())

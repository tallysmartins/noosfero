class SoftwareCommunitiesPlugin < Noosfero::Plugin
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::AssetTagHelper
  include FormsHelper
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  def self.plugin_name
    'SoftwareCommunitiesPlugin'
  end

  def self.plugin_description
    _('Add Public Software and MPOG features.')
  end

  def self.api_mount_points
    [SoftwareCommunitiesPlugin::API]
  end

  SOFTWARE_CATEGORIES = [
    _('Agriculture, Fisheries and Extraction'),
    _('Science, Information and Communication'),
    _('Economy and Finances'),
    _('Public Administration'),
    _('Habitation, Sanitation and Urbanism'),
    _('Individual, Family and Society'),
    _('Health'),
    _('Social Welfare and Development'),
    _('Defense and Security'),
    _('Education'),
    _('Government and Politics'),
    _('Justice and Legislation'),
    _('International Relationships'),
    _('Transportation and Transit')
  ]

  def profile_tabs
    if context.profile.community? && context.profile.software?
      return profile_tabs_software
    end
  end

  def control_panel_buttons
    if context.profile.software?
      return software_info_button
    elsif context.profile.person?
      return create_new_software_button
    end
  end

  def self.extra_blocks
    {
      SoftwareCommunitiesPlugin::SoftwaresBlock => { :type => [Environment, Person]  },
      SoftwareCommunitiesPlugin::SoftwareInformationBlock => {  :type => [Community]  },
      SoftwareCommunitiesPlugin::DownloadBlock => { :type => [Community] },
      SoftwareCommunitiesPlugin::RepositoryBlock => { :type => [Community] },
      SoftwareCommunitiesPlugin::CategoriesAndTagsBlock => { :type => [Community] },
      SoftwareCommunitiesPlugin::CategoriesSoftwareBlock => { :type => [Environment] },
      SoftwareCommunitiesPlugin::SearchCatalogBlock => { :type => [Environment] },
      SoftwareCommunitiesPlugin::SoftwareHighlightsBlock => { :type => [Environment] },
      SoftwareCommunitiesPlugin::SoftwareTabDataBlock => {:type => [Community], :position => 1},
      SispTabDataBlock => {:type => [Community], :position => 1},
      SoftwareCommunitiesPlugin::WikiBlock => {:type => [Community]},
      SoftwareCommunitiesPlugin::StatisticBlock => { :type => [Community] }
      SoftwareEventsBlock => { :type => [Community] }
    }
  end

  def self.software_categories
    software_category = Category.find_by_name("Software")
    if software_category.nil?
      []
    else
      software_category.children
    end
  end

  def stylesheet?
    true
  end

  def js_files
    %w(
      vendor/jquery.maskedinput.min.js
      vendor/modulejs-1.5.0.min.js
      vendor/jquery.js
      lib/noosfero-root.js
      lib/select-element.js
      lib/select-field-choices.js
      lib/auto-complete.js
      lib/software-catalog-component.js
      views/control-panel.js
      views/edit-software.js
      views/new-software.js
      views/search-software-catalog.js
      views/profile-tabs-software.js
      views/new-community.js
      views/comments-software-extra-fields.js
      blocks/software-download.js
      initializer.js
      app.js
    )
  end

  module Hotspots
    def display_organization_average_rating organization
      nil
    end
  end

  def organization_ratings_plugin_comments_extra_fields
    if context.profile.software?
      Proc::new { render :file => 'comments_extra_fields' }
    end
  end

  def organization_ratings_plugin_star_message
    Proc::new do _("Rate this software") end
  end

  def organization_ratings_title
    title = _('Use reports')
    Proc::new do "<h1 class='title'>#{title}</h1>" end
  end

  def organization_ratings_plugin_container_extra_fields user_rating
    Proc::new {
      if logged_in?
        is_admin = user.is_admin? || user_rating.organization.is_admin?(user)

        if is_admin and profile.software?

            render :file => 'organization_ratings_container_extra_fields_show_statistics',
                   :locals => {:user_rating => user_rating}
        end
      end
    }
  end

  def organization_ratings_plugin_rating_created rating, params
    if params[:organization_rating].present? && (params[:organization_rating][:people_benefited].present? ||
                                                  params[:organization_rating][:saved_value].present?)
      CreateOrganizationRatingComment.create!(
        :requestor => rating.person,
        :organization_rating_id => rating.id,
        :target => rating.organization) unless params[:comments] && params[:comments][:body].present?
    end
  end

  def organization_ratings_plugin_task_extra_fields user_rating
    Proc::new {
      if logged_in?
        is_admin = user.is_admin? || user_rating.organization.is_admin?(user)

        if is_admin and profile.software?
            render :file => 'organization_ratings_task_extra_fields_show_statistics',
                   :locals => {:user_rating => user_rating}
        end
      end
    }
  end

  def html_tag_classes
    lambda do
      "article-type-#{@page.css_class_name}" if @page
    end
  end

  # FIXME - if in error log apears has_permission?, try to use this method
  def has_permission?(person, permission, target)
    person.has_permission_without_plugins?(permission, target)
  end

  protected

  def software_info_transaction
    SoftwareCommunitiesPlugin::SoftwareInfo.transaction do
      context.profile.
        software_info.
        update_attributes!(context.params[:software_info])
    end
  end

  def license_transaction
    license = SoftwareCommunitiesPlugin::LicenseInfo.find(context.params[:version])
    context.profile.software_info.license_info = license
    context.profile.software_info.save!
  end

  private

  def software_info_button
    {
      :title => _('Software Info'),
      :icon => 'edit-profile-group control-panel-software-link',
      :url => {
        :controller => 'software_communities_plugin_myprofile',
        :action => 'edit_software'
      }
    }
  end

  def create_new_software_button
    {
      :title => _('Create a new software'),
      :icon => 'design-editor',
      :url => {
        :controller => 'software_communities_plugin_myprofile',
        :action => 'new_software'
      }
    }
  end

  def profile_tabs_software
    { :title => _('Software'),
      :id => 'software-fields',
      :content => Proc::new do render :partial => 'profile/software_tab' end,
      :start => true }
  end
end

require_dependency 'macros/allow_variables'

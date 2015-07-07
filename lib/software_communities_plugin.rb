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

  def profile_tabs
    if context.profile.community?
      return profile_tabs_software if context.profile.software?
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
      SoftwaresBlock => { :type => [Environment, Person]  },
      SoftwareInformationBlock => {  :type => [Community]  },
      DownloadBlock => { :type => [Community] },
      RepositoryBlock => { :type => [Community] },
      CategoriesAndTagsBlock => { :type => [Community] },
      CategoriesSoftwareBlock => { :type => [Environment] },
      SearchCatalogBlock => { :type => [Environment] }
    }
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

  def communities_ratings_plugin_comments_extra_fields
    Proc::new do render :file => 'comments_extra_fields' end
  end

  def communities_ratings_plugin_star_message
    Proc::new do _("Rate this software") end
  end

  # FIXME - if in error log apears has_permission?, try to use this method
  def has_permission?(person, permission, target)
    person.has_permission_without_plugins?(permission, target)
  end

  protected

  def software_info_transaction
    SoftwareInfo.transaction do
      context.profile.
        software_info.
        update_attributes!(context.params[:software_info])
    end
  end

  def license_transaction
    license = LicenseInfo.find(context.params[:version])
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

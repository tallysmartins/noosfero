require_dependency 'profile_editor_controller'

class ProfileEditorController

  before_filter :redirect_to_edit_software_community, :only => [:edit]

  def edit_software_community
    @profile_data = profile
    @possible_domains = profile.possible_domains

    edit_community_post_actions if request.post?
  end

  protected


  def redirect_to_edit_software_community
    if profile.class == Community && profile.software?
      redirect_to :action => 'edit_software_community'
    end
  end

  def edit_community_post_actions
    params[:profile_data][:fields_privacy] ||= {} if profile.person? && params[:profile_data].is_a?(Hash)

    Profile.transaction do
      Image.transaction do
        begin
          @plugins.dispatch(:profile_editor_transaction_extras)
          @profile_data.update_attributes!(params[:profile_data])

          redirect_to :action => 'index', :profile => profile.identifier
        rescue Exception => ex
          profile.identifier = params[:profile] if profile.identifier.blank?
        end
      end
    end
  end

end

require_dependency 'profile_editor_controller'

class ProfileEditorController

  before_filter :redirect_to_edit_software_community, :only => [:edit]

  def edit_software_community
    @profile_data = profile
    @possible_domains = profile.possible_domains

    edit if request.post?
  end

  protected

  def redirect_to_edit_software_community
    if profile.class == Community && profile.software?
      redirect_to :action => 'edit_software_community'
    end
  end

end

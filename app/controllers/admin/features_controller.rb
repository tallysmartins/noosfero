class FeaturesController < AdminController
  protect 'edit_environment_features', :environment
  
  def index
    @features = Environment.available_features.sort_by{|k,v|v}
  end

  post_only :update
  def update
    if @environment.update_attributes(params[:environment])
      session[:notice] = _('Features updated successfully.')
      redirect_to :action => 'index'
    else
      render :action => 'index'
    end
  end

  def manage_fields
    @person_fields = Person.fields
    @custom_person_fields = []
    @environment.settings[:custom_person_fields].each{|k,v| @custom_person_fields << k if k =~ /^custom_field/ && ! @custom_person_fields.include?(k) }
    @enterprise_fields = Enterprise.fields
    @community_fields = Community.fields
  end

  def manage_person_fields
    environment.custom_person_fields = params[:person_fields]

    #raise params[:person_fields].inspect

    if environment.save!
      session[:notice] = _('Person fields updated successfully.')
    else
      flash[:error] = _('Person fields not updated successfully.')
    end

    redirect_to :action => 'manage_fields'
  end

  def manage_enterprise_fields
    environment.custom_enterprise_fields = params[:enterprise_fields]
    if environment.save!
      session[:notice] = _('Enterprise fields updated successfully.')
    else
      flash[:error] = _('Enterprise fields not updated successfully.')
    end
    redirect_to :action => 'manage_fields'
  end

  def manage_community_fields
    environment.custom_community_fields = params[:community_fields]
    if environment.save!
      session[:notice] = _('Community fields updated successfully.')
    else
      flash[:error] = _('Community fields not updated successfully.')
    end
    redirect_to :action => 'manage_fields'
  end

end

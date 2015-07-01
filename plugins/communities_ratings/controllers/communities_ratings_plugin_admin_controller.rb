class CommunitiesRatingsPluginAdminController < PluginAdminController

  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def index
  end

  def update
    if @environment.update_attributes(params[:environment])
      session[:notice] = _('Configuration updated successfully.')
    else
      session[:notice] = _('Configuration could not be saved.')
    end
    render :action => 'index'
  end

end
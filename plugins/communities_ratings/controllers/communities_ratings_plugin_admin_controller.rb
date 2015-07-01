class CommunitiesRatingsPluginAdminController < PluginAdminController

  include RatingsHelper
  helper :ratings
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def index
  end

  def update
    if env_community_ratings_config.update_attributes(params[:community_ratings_config])
      session[:notice] = _('Configuration updated successfully.')
    else
      session[:notice] = _('Configuration could not be saved.')
    end
    render :action => 'index'
  end

end
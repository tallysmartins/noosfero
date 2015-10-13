class GovUserPluginMyprofileController < MyProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def index
  end

  def edit_institution
    @show_sisp_field = environment.admins.include?(current_user.person)
    @state_list = NationalRegion.find(
                    :all,
                    :conditions => { :national_region_type_id => 2 },
                    :order => 'name'
                  )
    @institution = @profile.institution
    update_institution if request.post?
  end

  private

  def update_institution
    @institution.community.update_attributes(params[:community])
    @institution.update_attributes(params[:institutions].except(:governmental_power, :governmental_sphere, :juridical_nature))
    if @institution.type == "PublicInstitution"
      begin
        governmental_updates
      rescue
        @institution.errors.add(:governmental_fields,
        _("Could not find Governmental Power or Governmental Sphere"))
      end
    end
    if @institution.valid?
      redirect_to :controller => 'profile_editor', :action => 'index', :profile => profile.identifier
    else
      flash[:errors] = @institution.errors.full_messages
    end
  end

  def governmental_updates
    gov_power = GovernmentalPower.find params[:institutions][:governmental_power]
    gov_sphere = GovernmentalSphere.find params[:institutions][:governmental_sphere]
    jur_nature = JuridicalNature.find params[:institutions][:juridical_nature]

    @institution.juridical_nature = jur_nature
    @institution.governmental_power = gov_power
    @institution.governmental_sphere = gov_sphere
    @institution.save
  end


end

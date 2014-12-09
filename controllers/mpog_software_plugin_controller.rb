require 'csv'
class MpogSoftwarePluginController < ApplicationController
  include InstitutionHelper

  def check_reactivate_account
    if request.xhr? && params[:email]
      result = ""
      user = User.where(:email => params[:email])

      if user.length == 1
        result = "<span id='forgot_link'><a href='/account/forgot_password'> Reactive account</a></span>" unless user[0].person.visible
      end

      render :json => result.to_json
    end
  end

  def hide_registration_incomplete_percentage
    response = false

    if request.xhr? && params[:hide]
      session[:hide_incomplete_percentage] = true
      response = session[:hide_incomplete_percentage]
    end

    render :json=>response.to_json
  end

  def create_institution
    @show_sisp_field = environment.admins.include?(current_user.person)
    @estate_list = get_state_list()

    if request.xhr?
      render :layout=>false
    else
      redirect_to "/"
    end
  end

  def split_http_referer http_referer
    split_list = []
    split_list = http_referer.split("/")
    @url_token = split_list.last
    return @url_token
  end

  def create_institution_admin
    @show_sisp_field = environment.admins.include?(current_user.person)
    @estate_list = get_state_list()

    @url_token = split_http_referer request.original_url()
  end

  def new_institution
    redirect_to "/" if params[:community].blank? || params[:institutions].blank?

    response_message = {}

    institution_template = Community["institution"]
    add_template_in_params institution_template

    institution = private_create_institution
    add_environment_admins_to_institution institution

    response_message = save_institution institution

    if request.xhr? #User create institution
      render :json => response_message.to_json
    else #Admin create institution
      session[:notice] = response_message[:message] # consume the notice

      redirect_depending_on_institution_creation response_message
    end
  end

  def institution_already_exists
    redirect_to "/" if !request.xhr? || params[:name].blank?

    already_exists = !Community.where(:name=>params[:name]).empty?

    render :json=>already_exists.to_json
  end

  def download
    respond_to do |format|
      format.html
      format_xml_download format
      format_csv_download format
    end
  end

  def get_institutions
    redirect_to "/" if !request.xhr? || params[:query].blank?

    list = Institution.search_institution(params[:query]).map{ |institution|
      {:value=>institution.name, :id=>institution.id}
    }

    render :json => list.to_json
  end

  def get_categories
    redirect_to "/" if !request.xhr? || params[:query].blank?

    list = []

    Category.where("name ILIKE ?", "%#{params[:query]}%").collect { |c|
      list << {:label=>c.name, :id=>c.id} if c.name != "Software"
    }

    render :json => list.to_json
  end

  def get_brazil_states
    redirect_to "/" unless request.xhr?

    state_list = get_state_list()
    render :json=>state_list.collect {|state| state.name }.to_json
  end

  def get_field_data
    return render :json=>{} if !request.xhr? || params[:query].nil? || params[:field].nil?

    model = case params[:field]
      when "database"
        DatabaseDescription
      when "software_language"
        ProgrammingLanguage
      else
        DatabaseDescription
      end

    data = model.where("name ILIKE ?", "%#{params[:query]}%").select("id, name").collect { |db|
      {:id=>db.id, :label=>db.name}
    }
    other = [model.select("id, name").last].collect { |db|
      {:id=>db.id, :label=>db.name}
    }

    # Always has other in the list
    data |= other

    render :json=> data
  end

  protected

  def get_state_list
    redirect_to "/" unless request.xhr?

    NationalRegion.find(:all, :conditions=>["national_region_type_id = ?", 2], :order=>"name")
  end

  def private_create_institution
    community = Community.new(params[:community])
    community.environment = environment

    institution = if params[:institutions][:type] == "PublicInstitution"
      PublicInstitution::new params[:institutions].except(:governmental_power, :governmental_sphere, :juridical_nature)
    else
      PrivateInstitution::new params[:institutions].except(:governmental_power, :governmental_sphere, :juridical_nature)
    end

    institution.name = community[:name]
    institution.community = community

    if institution.type == "PublicInstitution"
      begin
        govPower = GovernmentalPower.find params[:institutions][:governmental_power]
        govSphere = GovernmentalSphere.find params[:institutions][:governmental_sphere]
        jur_nature = JuridicalNature.find params[:institutions][:juridical_nature]

        institution.juridical_nature = jur_nature
        institution.governmental_power = govPower
        institution.governmental_sphere = govSphere
      rescue
        institution.errors.add(:governmental_fields, _("Could not find Governmental Power or Governmental Sphere"))
      end
    end

    InstitutionHelper.register_institution_modification institution

    institution
  end

  def software_list_to_correct_format software_list=[]
    if !software_list.empty?
      software_list.each do |software|
        software[:name] = Community.find(software.community_id).name
        software[:languages_list] = []

        software.software_languages.each do |sl|
          software[:languages_list] << {}
          index =  software[:languages_list].count - 1
          software[:languages_list][index][:name] = ProgrammingLanguage.find(sl.programming_language_id).name
          software[:languages_list][index][:version] = sl.version
          software[:languages_list][index][:operating_system] = sl.operating_system
        end

        software[:database_list] = []
        software.software_databases.each do |dd|
          software[:database_list] << {}
          index =  software[:database_list].count - 1
          software[:database_list][index][:name] = DatabaseDescription.find(dd.database_description_id).name
          software[:database_list][index][:version] = dd.version
          software[:database_list][index][:operating_system] = dd.operating_system
        end
      end
    end
    software_list
  end

  def add_template_in_params institution_template
    if (!institution_template.blank? && institution_template.is_template)
      params[:community][:template_id] = institution_template.id unless params[:community].blank?
    end
  end

  def add_environment_admins_to_institution institution
    if environment.admins.include?(current_user.person) && params[:edit_institution_page] == false
      environment.admins.each do |adm|
        institution.community.add_admin(adm)
      end
    end
  end

  def save_institution institution
    if institution.errors.full_messages.empty? and institution.community.errors.full_messages.empty? and institution.valid? and institution.save
      {:success => true, :message => _("Institution successful created!"), :institution_data=>{:name=>institution.name, :id=>institution.id}}
    else
      {:success => false, :message => _("Institution could not be created!"), :errors => institution.errors.full_messages << institution.community.errors.full_messages}
    end
  end

  def redirect_depending_on_institution_creation response_message
    if response_message[:success]
      redirect_to :controller => "/admin_panel", :action => "index"
    else
      flash[:errors] = response_message[:errors]
      redirect_to :controller => "mpog_software_plugin", :action => "create_institution_admin"
    end
  end

  def format_xml_download format
    format.xml do
      softwares = software_list_to_correct_format(SoftwareInfo.all)
      send_data(
        softwares.to_xml(
          :skip_types => true,
          :only => %w[name acronym demonstration_url e_arq e_mag e_ping features icp_brasil objectives operating_platform languages_list database_list]
        ),
        :type => 'text/xml',
        :disposition => "attachment; filename=softwares.xml")
    end
  end

  def format_csv_download format
    format.csv do
      softwares = software_list_to_correct_format(SoftwareInfo.all)
      csv_content = ""

      softwares.each do |s|
        csv_content << "name;acronym;demonstration_url;e_arq;e_mag;e_ping;features;icp_brasil;objectives;operating_platform\n"
        csv_content << CSV.generate_line([s['name'], s['acronym'], s['demonstration_url'], s['e_arq'], s['e_mag'], s['e_ping'], s['features'], s['icp_brasil'], s['objectives'], s['operating_platform']], {:col_sep => ';'})

        csv_content << "\nlanguage_name;language_version;language_operating_system\n"
        s[:languages_list].each { |sl|
          csv_content << CSV.generate_line([sl[:name], sl[:version], sl[:operating_system]], {:col_sep => ';'})
        }

        csv_content << "\ndatabase_name;database_version;database_operating_system\n"
        s[:database_list].each { |dl|
          csv_content << CSV.generate_line([dl[:name], dl[:version], dl[:operating_system]], {:col_sep => ';'})
        }

        csv_content << "\n\n"
      end

      if csv_content.blank?
        csv_content = "name;acronym;demonstration_url;e_arq;e_mag;e_ping;features;icp_brasil;objectives;operating_platform\n"
      end

      render :text => csv_content, :content_type => 'text/csv', :layout => false
    end
  end
end

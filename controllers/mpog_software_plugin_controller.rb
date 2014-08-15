require 'csv'
class MpogSoftwarePluginController < ApplicationController

  def archive_software
    per_page = 10
    scope = SoftwareInfo
    @q = params[:q]
    @collection = find_by_contents(:community, scope, @q, {:per_page => per_page, :page => params[:npage]})[:results]
  end

  def deactivate
   community = SoftwareInfo.find(params[:id]).community_id
   Community.find(community).deactivate
   if params[:from_profile]
      redirect_to :back
   else
      redirect_to :action => 'archive_software'
   end
  end

  def activate
   community = SoftwareInfo.find(params[:id]).community_id
   Community.find(community).activate
   redirect_to :action => 'archive_software'
  end

  def check_reactivate_account
    if request.xhr? and params[:email]
      result = ""
      user = User.where(:email => params[:email])

      if user.length == 1
        result = "<span id='forgot_link'><a href='/account/forgot_password'> Reactive account</a></span>" unless user[0].person.visible
      end

      render :json => result.to_json
    end
  end

  def get_institutions
    list = []

    if request.xhr? and params[:query]
      list = Institution.search_institution(params[:query]).map{ |institution|
        {:value=>institution.name, :id=>institution.id}
      }
    end

    render :json => list.to_json
  end

  def hide_registration_incomplete_percentage
    response = false

    if request.xhr? and params[:hide]
      session[:hide_incomplete_percentage] = true
      response = session[:hide_incomplete_percentage]
    end

    render :json=>response.to_json
  end

  def create_institution
    if request.xhr?
      render :layout=>false
    else
      redirect_to "/"
    end
  end

  def new_institution
    if request.xhr? and !params[:community].nil? and !params[:institution].nil? and !params[:recaptcha_response_field].nil?
      response_message = {}

      institution = private_create_institution

      response_message = if verify_recaptcha(:model=> institution, :message => _('Please type the word correctly'))
        if institution.errors.full_messages.empty? and institution.valid? and institution.save
          institution.community.add_admin(environment.admins.first) unless environment.admins.empty?

          {:success => true, :message => _("Institution successful created!"), :institution_data=>{:name=>institution.name, :id=>institution.id}}
        else
          {:success => false, :message => _("Institution could not be created!"), :errors => institution.errors.full_messages}
        end
      else
        {:success => false, :message=>_('Please type the image text correctly'), :errors=>[]}
      end

      render :json => response_message.to_json
    else
      redirect_to "/"
    end
  end

  def institution_already_exists
    if request.xhr? and !params[:name].nil?
      already_exists = !Community.where(:name=>params[:name]).empty?

      render :json=>already_exists.to_json
    else
      redirect_to "/"
    end
  end

  def download
    respond_to do |format|
      format.html
      format.xml do
        softwares = software_list_to_correct_format(SoftwareInfo.all)
        send_data softwares.to_xml(
            :skip_types => true,
            :only => %w[name acronym demonstration_url e_arq e_mag e_ping features icp_brasil objectives operating_platform languages_list database_list]),
          :type => 'text/xml',
          :disposition => "attachment; filename=softwares.xml"
      end

      format.csv do
        softwares = software_list_to_correct_format(SoftwareInfo.all)
        csv_content = ""
        softwares.each { |s|
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
        }
        if csv_content.blank?
          csv_content = "name;acronym;demonstration_url;e_arq;e_mag;e_ping;features;icp_brasil;objectives;operating_platform\n"
        end

        render :text => csv_content, :content_type => 'text/csv', :layout => false
      end
    end
  end


  protected

  def private_create_institution
    community = Community.new(params[:community])
    community.environment = environment

    institution = if params[:institution][:type] == "PublicInstitution"
      PublicInstitution::new params[:institution]
    else
      PrivateInstitution::new params[:institution]
    end

    institution.name = community[:name]
    institution.community = community

    if institution.type == "PublicInstitution"
      begin
        govPower = GovernmentalPower.find params[:governmental][:power]
        govSphere = GovernmentalSphere.find params[:governmental][:sphere]

        institution.governmental_power = govPower
        institution.governmental_sphere = govSphere
      rescue
        institution.errors.add(:governmental_fields, _("Could not find Governmental Power or Governmental Sphere"))
      end
    end

    if institution.cnpj.nil? or institution.cnpj.blank?
      institution.errors.add(:cnpj, _("can't be blank"))
    end

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

end

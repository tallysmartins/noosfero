require "net/http"
require "yaml"

module InstitutionHelper

  SPHERES = ['federal']
  POWERS = ['executive', 'legislative', 'judiciary']

  def self.mass_update
    @web_service_info = self.web_service_info

    environment = Environment.find_by_name(@web_service_info["environment_name"])

    if environment.nil?
      puts "\n", "="*80, "Could not find the informed environment: #{@web_service_info["environment_name"]}", "="*80, "\n"
      return
    end

    admin = environment.people.find_by_name(@web_service_info["default_community_admin"])

    if admin.nil?
      puts "\n", "="*80, "Could not find the informed admin: #{@web_service_info["default_community_admin"]}", "="*80, "\n"
      return
    end

    POWERS.each do |power|
      SPHERES.each do |sphere|
        json = self.get_json power, sphere

        units = json["unidades"]

        units.each do |unit|
          institution = PublicInstitution.where(:name=>unit["nome"])

          institution = if institution.count == 0
            PublicInstitution::new
          else
            institution.first
          end

          institution = self.set_institution_data institution, unit
          institution.save
          institution.community.add_admin(admin)
        end
      end
    end
  end

  def self.register_institution_modification institution
    institution.date_modification = current_date
    institution.save
  end

  protected

  def self.web_service_info
    YAML.load_file(File.dirname(__FILE__) + '/../config/siorg.yml')['web_service']
  end

  def self.service_url power, sphere
    base_url = @web_service_info['base_url']
    power_code = @web_service_info['power_codes'][power].to_s
    sphere_code = @web_service_info['sphere_codes'][sphere].to_s
    additional_params = @web_service_info['additional_params']

    return URI("#{base_url}?codigoPoder=#{power_code}&codigoEsfera=#{sphere_code}&#{additional_params}")
  end

  def self.get_json power, sphere
    uri = self.service_url power, sphere #URI(BASE_URL+"codigoPoder=#{power_code}&codigoEsfera=#{sphere_code}&retornarOrgaoEntidadeVinculados=NAO")
    data = Net::HTTP.get(uri)
    ActiveSupport::JSON.decode(data)
  end

  def self.retrieve_code unit, field
    data = unit[field]
    return data.split("/").last unless (data.blank? || data.nil?)
    return nil
  end

  def self.set_institution_data institution, unit

    community = if Community.where(:name=>unit["nome"]).length != 0
      Community.where(:name=>unit["nome"]).first
    else
      Community.new :name=>unit["nome"]
    end

    institution.community = community
    institution.name = unit["nome"]
    institution.acronym  = unit["sigla"]
    institution.unit_code = self.retrieve_code(unit,"codigoUnidade")
    institution.parent_code = self.retrieve_code(unit,"codigoUnidadePai")
    institution.unit_type = self.retrieve_code(unit,"codigoTipoUnidade")
    institution.juridical_nature = JuridicalNature.where(:name=>self.retrieve_code(unit,"codigoNaturezaJuridica").titleize).first
    institution.sub_juridical_nature = self.retrieve_code(unit,"codigoSubNaturezaJuridica")
    institution.normalization_level = unit["nivelNormatizacao"]
    institution.version = unit["versaoConsulta"]
    institution.governmental_power = GovernmentalPower.where(:name=>self.retrieve_code(unit,"codigoPoder").capitalize).first
    institution.governmental_sphere = GovernmentalSphere.where(:name=>self.retrieve_code(unit,"codigoEsfera").capitalize).first
    institution
  end

  def self.current_date
    date = Time.now.day.to_s + "/" + Time.now.month.to_s + "/" + Time.now.year.to_s
    date
  end
end

# encoding: UTF-8

namespace :sisp do
  desc "Creates SISP env and templates"
  task :prepare => :environment do
    unless ENV["DOMAIN"].present?
      puts "You didn't choose any domain. The default domain is 'novo.sisp.gov.br'"
      puts "You can run rake sisp:prepare DOMAIN=domain.url to add a domain"
    end

    unless ENV["ADMINUSER"].present?
      puts "You didn't enter any user to be selected from the default Environment"
      puts "You can run rake sisp:prepare ADMINUSER=jose"
    end

    Rake::Task['sisp:create_env'].invoke
    Rake::Task['noosfero:plugins:enable_all'].invoke
    Rake::Task['sisp:create_template'].invoke
  end

  desc "Create SISP environment and import data"
  task :all => [:prepare, :import_data]

  desc "Creates the SISP Environment"
  task :create_env => :environment do
    env = Environment.find_or_create_by_name("SISP")
    domain_name = ENV["DOMAIN"] || "novo.sisp.gov.br"
    domain = Domain.find_or_create_by_name(domain_name)
    env.domains << domain unless env.domains.include?(domain)

    env.theme = "noosfero-spb-theme"
    create_link_blocks env
    env.save

    user = Environment.default.users.find_by_login(ENV["ADMINUSER"])
    if user.present?
      password = SecureRandom.base64
      sisp_user = env.users.find_by_login(user.login)

      unless sisp_user.present?
        sisp_user = User.new(:login => user.login, :email => user.email, :password => password, :password_confirmation => password, :environment => env)
      end

      sisp_user.save
      sisp_user.activate
      env.add_admin sisp_user.person

      puts "User created with a random password. You can change in the console." unless sisp_user.save
    else
      puts "\nWARNING!!!!!!***********************************************"
      puts "No user found with the given login '#{ENV['ADMINUSER']}'.... skipping"
      puts "You can run this task again passing a valid user login with the following command:"
      puts "rake sisp:create_env ADMINUSER=userlogin"
    end
    puts "\n\nSISP Environment created"
  end

  def create_link_blocks template
    box_2 = template.boxes.find_by_position(2)
    box_2.blocks.destroy_all
    box_2.blocks << LinkListBlock.new(:mirror => true,
                                      :links => [{:name=>"Catálogo de Software", :address=>"/search/sisp", :target=>"_self"},
                                                 {:name=>"Ajuda", :address=>"/", :target=>"_self"}])
    box_2.blocks << LinkListBlock.new(:title => "Software SISP", :mirror => true,
                                      :links => [{:name=>"Publique seu Software", :address=>"/", :target=>"_self"},
                                                 {:name=>"Vídeos", :address=>"/", :target=>"_self"}])
    box_2.blocks << LinkListBlock.new(:title => "Portal do SISP", :mirror => true,
                                      :links => [{:name=>"Sobre o Portal", :address=>"/", :target=>"_self"},
                                                 {:name=>"Contato", :address=>"/", :target=>"_self"},
                                                 {:name=>"Notícias", :address=>"/", :target=>"_self"}])
  end

  desc "Creates SISP software template"
  task :create_template => :environment do
    env = Environment.find_by_name("SISP")

    unless env.present?
      Rake::Task['sisp:create_env'].invoke
      env = Environment.find_by_name("SISP")
    end

    if env.present?
      template = Community.where(identifier: "sisp", environment_id: env).last
      template.destroy if template
      template = Community.create!(name: "Sisp", identifier: "sisp", is_template: true, environment: env)

      template.home_page = template.blog
      template.update_layout_template("nosidebars")
      template.save

      create_template_blocks template
      create_link_blocks template

      env.community_default_template = template
      env.save!

      puts "SISP Template created"
    else
      puts "SISP Template *NOT* created. Environment SISP not found."
    end

  end

  def create_template_blocks template
    box_1 = template.boxes.find_by_position(1)
    box_1.blocks << SoftwareInformationBlock.new(:display => "home_page_only", :mirror => true)
    box_1.blocks << SispTabDataBlock.new(:display => "home_page_only", :mirror => true)
    box_1.blocks << CategoriesAndTagsBlock.new(:display => "home_page_only", :mirror => true)
    box_1.blocks << OrganizationRatingsBlock.new(:display => "home_page_only", :mirror => true, :title => "Relatos de uso")

    main_block = box_1.blocks.find_by_type("MainBlock")
    main_block.display = "except_home_page"
    main_block.save
  end

  desc "Import sisp software from yml"
  task :import_data => :environment do
    $imported_data = YAML.load_file('plugins/software_communities/public/static/sisp-catalog.yml')
    $env = Environment.find_by_name("SISP")
    unless $env
      puts "SISP environment not FOUND!"
      exit 1
    end

    $license = LicenseInfo.find_or_create_by_version("Another")
    $software_category = $env.categories.find_or_create_by_name("Software")
    $software_category.environment = $env
    $software_category.save!

    $sisp_user = create_sisp_user

    $created_software={}

    $sisp_template = $env.communities.find_by_identifier("sisp")

    print 'Creating SISP Softwares: '
    $imported_data.keys.each do |key|

      sisp = $imported_data[key]['software_info']

      next if sisp['3 - Identificação do software']['Nome'].size <= 2
      sw = create_software_and_attrs sisp

      sw.sisp_url = $imported_data[key]['url']
      sw.sisp = true
      sw.sisp_id = key.to_i

      set_sisp_hashes sw, sisp

      if sw.valid? && sw.community.valid?
        sw.community.save!
        sw.save!
        print '.'
      else
        sw.community.destroy
        sw.destroy
        puts sw.errors.full_messages
        print 'F'
      end
    end

    puts "\n Done"
  end
end

def create_sisp_community name

  identifier = create_identifier name

  $created_software[identifier]= $created_software[identifier].nil? ? 0 : $created_software[identifier]+1

  name = name + " copy#{$created_software[identifier]}" if ($created_software[identifier] != 0)
  identifier = (identifier + "-copy#{$created_software[identifier]}") if ($created_software[identifier] != 0)

  community = $env.communities.find_or_initialize_by_name(name)

  community.identifier = identifier
  community.template = $sisp_template
  community.environment = $env

  community.save!
  community
end

def create_sisp_software_info name, finality = "blank", acronym = ""
  community = create_sisp_community(name)

  if community.software?
    return community.software_info
  end

  software_info = SoftwareInfo.new
  software_info.license_info = $license
  software_info.community = community
  software_info.finality = finality
  software_info.acronym = acronym
  software_info.save!
  software_info
end

def set_software_category software, category_name
  category = $env.categories.find_by_name(category_name)
  category ||= Category.create(:name => category_name, :parent => $software_category, :environment => $env)
  software.community.categories << category unless software.community.categories.include?(category)
end

def set_sisp_hashes software, sisp_hash
  software.sisp_type = sisp_hash['3 - Identificação do software']['Tipo de Software']
  software.agency_identification = sisp_hash['1 - Identificação do órgão']
  software.software_requirements = sisp_hash['10 - Requisitos de software']
  software.hardware_requirements = sisp_hash['11 - Requisitos de Hardware']
  software.documentation = sisp_hash['12 - Documentação']
  software.system_applications = sisp_hash['13 - Aplicações do sistema']
  software.active_versions = sisp_hash['15 - Versões em uso']
  software.estimated_cost = sisp_hash['16 - Custo Estimado']
  software.responsible = sisp_hash['2 - Identificação do responsável no órgão para contato posterior']
  software.responsible_for_acquirement = sisp_hash['4 - Responsáveis pelo Desenvolvimento/Aquisição']
  software.system_info = sisp_hash['5 - Sistema']
  software.development_info = sisp_hash['6 - Características do Desenvolvimento']
  software.maintenance = sisp_hash['7 - Manutenção do Sistema']
  software.standards_adherence = sisp_hash['8 - Aderência a padrões']
  software.platform = sisp_hash['9 - Ambiente / Plataforma']
end

def create_identifier name
  "#{name.to_slug}".truncate(240, :omission => '', :separator => '-')
end

def create_sisp_user #TODO change user info
  user = $env.users.find_by_login('sisp_admin')
  password = SecureRandom.base64
  user ||= User.new(:login => 'sisp_admin', :email => 'sisp_user@changeme.com', :password => password, :password_confirmation => password, :environment => $env)
  user.save!
  user.activate if !user.activated?
  user
end

def create_institution sisp_hash

  name = sisp_hash['1 - Identificação do órgão']['Nome da Empresa/Órgão']

  if name.size <=2
    return nil
  end

  institution_community = $env.communities.find_or_initialize_by_identifier(name.to_slug)

  #puts institution_community.inspect
  institution = PublicInstitution.find_or_initialize_by_name(name)
  institution_community.name = name
  institution_community.country = "BR"
  institution_community.state = "DF"
  institution_community.city = "Unknown"
  institution_community.environment = $env
  institution_community.save!

  institution.community = institution_community
  institution.name = name
  institution.juridical_nature = JuridicalNature.find_or_create_by_name(:name => sisp_hash['1 - Identificação do órgão']['Natureza'])
  institution.acronym = sisp_hash['1 - Identificação do órgão']['Sigla'].split[0]
  institution.acronym = nil if (institution.acronym.size > 10)
  institution.governmental_power = GovernmentalPower.find_or_create_by_name(:name => sisp_hash['1 - Identificação do órgão']['Esfera'])
  institution.governmental_sphere = GovernmentalSphere.find_or_create_by_name(:name => sisp_hash['1 - Identificação do órgão']['Abrangência'])
  institution.cnpj = nil
  institution.corporate_name = name
  institution.save!
  institution

end

def create_ratings community_identifier, sisp_hash
  software_community = $env.communities.find_by_identifier(community_identifier)

  institution = create_institution(sisp_hash)
  if institution.nil?
    return nil
  end

  comment_system = Comment.new(:body=>"Informações de custo de sistema importadas automaticamente do catálogo SISP.", :author=> $sisp_user.person)
  comment_system.source = software_community
  comment_system.save!
  comment_maintenance = Comment.new(:body=>"Informações de custo de manutenção importadas automaticamente do catálogo SISP.", :author=> $sisp_user.person)
  comment_maintenance.source = software_community
  comment_maintenance.save!

  OrganizationRating.create!(
      :comment => comment_system,
      :value => 1, #TODO see what to put here
      :person => $sisp_user.person,
      :organization => software_community,
      :institution => institution,
      :saved_value => sisp_hash['16 - Custo Estimado']['Custo do sistema'],
      :people_benefited => 0
)

  OrganizationRating.create!(
      :comment => comment_maintenance,
      :value => 1,  #TODO see what to put here
      :person => $sisp_user.person,
      :organization => software_community,
      :institution => institution,
      :saved_value => sisp_hash['16 - Custo Estimado']['Custo de Manutenção'],
      :people_benefited => 0
  )

end

def create_software_and_attrs sisp_hash
  name = sisp_hash['3 - Identificação do software']['Nome'].truncate(240, :omission => '', :separator => ' ')

  identifier = create_identifier name

  software = create_sisp_software_info(name)

  create_ratings identifier, sisp_hash

  set_software_category software, sisp_hash['3 - Identificação do software']['Subtipo']
  software.features = sisp_hash['5 - Sistema']['Principais funcionalidades']
  software.finality = sisp_hash['5 - Sistema']['Objetivos do sistema']
  software.objectives = sisp_hash['5 - Sistema']['Objetivos do sistema']
  software.acronym = sisp_hash['3 - Identificação do software']['Sigla'].split[0]
  software.acronym = "" if (software.acronym.size > 10)
  software
end


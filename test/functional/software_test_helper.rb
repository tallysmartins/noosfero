module SoftwareTestHelper

  def create_language language_fields
    language = SoftwareLanguage.new

    language_fields[0].each do |k,v|
        language[k] = v
    end
    language.save!
    language
  end

  def create_database database_fields

    database  = SoftwareDatabase.new

    database_fields[0].each do |k,v|
        database[k] = v
    end

    database.save!
    database
  end

  def create_library library_fields
    library = Library.new

    library_fields[0].each do |k,v|
        library[k] = v
    end
  library.save!
  library
  end

  def create_operating_system operating_system_hash
    operating_system = OperatingSystem.new

    operating_system_hash[0].each do |k,v|
        operating_system[k] = v
    end
    operating_system.save
    operating_system
  end

  def create_license license_hash
    license_info = LicenseInfo.new

    license_hash.each do |k,v|
      license_info[k] = v
    end
    license_info.save
    license_info
  end

  def create_categories categories_hash
    software_categories = SoftwareCategories.new

    categories_hash.each do |k,v|
      software_categories[k] = v
    end
    software_categories.save
    software_categories
  end

  def create_software fields

    software = SoftwareInfo.new
    community = Community.new
    software_hash = fields[0]
    library_hash = fields[1]
    language_hash = fields[2]
    database_hash = fields[3]
    operating_system_hash  = fields[4]
    license_system_hash = fields[5]
    community_hash = fields[6]
    categories_hash = fields[7]

    software_hash.each do |k,v|
      software[k] = v
    end

    community_hash.each do |k,v|
      community[k] = v
    end

    community.save!
    software.community = community
    software.software_databases << create_database(database_hash)
    software.software_languages << create_language(language_hash)
    software.operating_systems << create_operating_system(operating_system_hash)
    software.license_info_id = license_system_hash
    software.libraries << create_library(library_hash)
    software.software_categories = create_categories(categories_hash)

    software
  end

  def software_fields

    fields = Hash.new
    fields_library = Hash.new
    fields_language = Hash.new
    fields_database = Hash.new
    fields_operating_system = Hash.new
    fields_community = Hash.new
    fields_license = Hash.new
    list_database = []
    list_language = []
    list_operating_system = []
    list_library = []

    #Fields for library
    fields_library['version'] = 'test'
    fields_library['name'] = 'test'
    fields_library['license'] = 'test'
    list_library << fields_library
    list_library << {}
    #Fields for software language
    fields_language['version'] = 'test'
    fields_language['programming_language_id'] = ProgrammingLanguage.last.id
    fields_language['operating_system'] = 'test'
    list_language << fields_language
    list_language << {}
    #Fields for database
    fields_database['version'] = 'test'
    fields_database['database_description_id'] = DatabaseDescription.last.id
    fields_database['operating_system'] = 'test'
    list_database << fields_database
    list_database << {}
    #Fields for license info
    fields_license['version'] = LicenseInfo.last.version
    #Fields for operating system
    fields_operating_system['version'] = 'version'
    fields_operating_system['operating_system_name_id'] = OperatingSystemName.last.id
    list_operating_system << fields_operating_system
    list_operating_system << {}
    #Fields for community
    fields_community['name'] = 'Debian'
    fields_community['identifier'] = 'debian'

    fields['acronym'] = 'test'
    fields['objectives'] = 'test'
    fields['features'] = 'test'
    fields['operating_platform'] = 'operating_plataform_test'
    fields['demonstration_url'] = 'test'

    fields_categories = {}
    fields_categories["administration"] = true
    fields_categories["agriculture"] = "1"
    fields_categories["business_and_services"] = "1"
    fields_categories["communication"] = "1"
    fields_categories["culture"] = "1"
    fields_categories["national_defense"] = "1"
    fields_categories["economy_and_finances"] = "1"
    fields_categories["education"] = "1"
    fields_categories["energy"] = "1"
    fields_categories["sports"] = "1"
    fields_categories["habitation"] = "1"
    fields_categories["industry"] = "1"
    fields_categories["environment"] = "1"
    fields_categories["research_and_development"] = "1"
    fields_categories["social_security"] = "1"
    fields_categories["social_protection"] = "1"
    fields_categories["sanitation"] = "1"
    fields_categories["health"] = "1"
    fields_categories["security_public_order"] = "1"
    fields_categories["work"] = "1"
    fields_categories["transportation"] = "1"
    fields_categories["urbanism"] = "1"

    hash_list = []
    hash_list << fields
    hash_list << list_library
    hash_list << list_language
    hash_list << list_database
    hash_list << list_operating_system
    hash_list << fields_license
    hash_list << fields_community
    hash_list << fields_categories
    hash_list
  end
end

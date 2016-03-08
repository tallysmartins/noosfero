module SoftwareTestHelper

  def create_language language_fields
    language = SoftwareCommunitiesPlugin::SoftwareLanguage.new

    language_fields[0].each do |k,v|
        language[k] = v
    end
    language.save!
    language
  end

  def create_database database_fields

    database  = SoftwareCommunitiesPlugin::SoftwareDatabase.new

    database_fields[0].each do |k,v|
        database[k] = v
    end

    database.save!
    database
  end

  def create_library library_fields
    library = SoftwareCommunitiesPlugin::Library.new

    library_fields[0].each do |k,v|
        library[k] = v
    end
  library.save!
  library
  end

  def create_operating_system operating_system_hash
    operating_system = SoftwareCommunitiesPlugin::OperatingSystem.new

    operating_system_hash[0].each do |k,v|
        operating_system[k] = v
    end
    operating_system.save
    operating_system
  end

  def create_license license_hash
    license_info = SoftwareCommunitiesPlugin::LicenseInfo.new

    license_hash.each do |k,v|
      license_info[k] = v
    end
    license_info.save
    license_info
  end

  def create_categories categories_hash
    software_categories = SoftwareCommunitiesPlugin::SoftwareCategories.new

    categories_hash.each do |k,v|
      software_categories[k] = v
    end
    software_categories.save
    software_categories
  end

  def create_software fields

    software = SoftwareCommunitiesPlugin::SoftwareInfo.new
    community = Community.new
    software_hash = fields[2]
    license_system_hash = fields[0]
    community_hash = fields[1]

    software_hash.each do |k,v|
      software[k] = v
    end

    community_hash.each do |k,v|
      community[k] = v
    end

    community.save!
    software.community = community
    software.license_info_id = license_system_hash[:license_infos_id]

    software.save!

    software
  end

  def software_edit_basic_fields
    fields = Hash.new
    fields_license = Hash.new
    hash_list = []

    fields['repository_link'] = 'www.github.com/test'
    fields['finality'] = 'This is the new finality of the software'
    hash_list << fields

    #Fields for license info
    fields_license['license_infos_id'] = SoftwareCommunitiesPlugin::LicenseInfo.last.id
    hash_list << fields_license

    hash_list
  end

  def software_edit_specific_fields
    fields_library = Hash.new
    fields_language = Hash.new
    fields_database = Hash.new
    fields_operating_system = Hash.new
    fields_software = Hash.new
    fields_categories = Hash.new
    fields_license = Hash.new

    hash_list = []
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
    hash_list << list_library

    #Fields for software language
    fields_language['version'] = 'test'
    fields_language['programming_language_id'] = SoftwareCommunitiesPlugin::ProgrammingLanguage.last.id
    fields_language['operating_system'] = 'test'
    list_language << fields_language
    list_language << {}
    hash_list << list_language

    #Fields for database
    fields_database['version'] = 'test'
    fields_database['database_description_id'] = SoftwareCommunitiesPlugin::DatabaseDescription.last.id
    fields_database['operating_system'] = 'test'
    list_database << fields_database
    list_database << {}
    hash_list << list_database

    #Fields for operating system
    fields_operating_system['version'] = 'version'
    fields_operating_system['operating_system_name_id'] = SoftwareCommunitiesPlugin::OperatingSystemName.last.id
    list_operating_system << fields_operating_system
    list_operating_system << {}
    hash_list << list_operating_system

    #software fields
    fields_software['acronym'] = 'test'
    fields_software['operating_platform'] = 'Linux'
    fields_software['objectives'] = 'This is the objective of the software'
    fields_software['features'] = 'This software does nothing'
    fields_software['demonstration_url'] = 'www.test.com'
    hash_list << fields_software

    #Fields for license
    fields_license['license_infos_id'] = SoftwareCommunitiesPlugin::LicenseInfo.last.id
    hash_list << fields_license

    hash_list
  end

  def software_fields
    hash_list = []

    #Fields for license info
    fields_license = {
      license_infos_id: SoftwareCommunitiesPlugin::LicenseInfo.last.id
    }
    hash_list << fields_license

    #Fields for community
    fields_community = {
      name: 'Debian',
      identifier: 'debian'
    }
    hash_list << fields_community

    #Fields for basic information
    fields = {
      finality: 'This is the finality of the software'
    }
    hash_list << fields

    hash_list
  end
end
#version: LicenseInfo.last.version,
#id: LicenseInfo.last.id

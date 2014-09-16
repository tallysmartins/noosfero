module SoftwareHelper

  def create_language language_fields
    language = SoftwareLanguage.new

    language_fields.each do |k,v|
      language[k] = v
    end
    language.save
    language
  end

  def create_database database_fields
  
    database  = SoftwareDatabase.new

    database_fields.each do |k,v|
      database[k] = v
    end
    
    database.save
    database
  end

  def create_library library_fields
    library = Library.new
   
    library_fields.each do |k,v|
      library[k] = v
    end
  library.save
  library
  end

  def create_operating_system operating_system_hash
    operating_system = OperatingSystem.new

    operating_system_hash.each do |k,v|
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
  def create_software fields 

    software = SoftwareInfo.new
    software_hash = fields[0]
    library_hash = fields[1]
    language_hash = fields[2]
    database_hash = fields[3]
    operating_system_hash  = fields[4]
    license_system_hash = fields[5]

    software_hash.each do |k,v|
      software[k] = v
    end

    community = Community.new
    community.name = "debian"
    community.save
    software.community = community
    software.software_databases << create_database(database_hash)
    software.software_languages << create_language(language_hash)
    software.operating_systems << create_operating_system(operating_system_hash)
    software.license_info = create_license(license_system_hash)
    software.libraries << create_library(library_hash)

    software
  end
end

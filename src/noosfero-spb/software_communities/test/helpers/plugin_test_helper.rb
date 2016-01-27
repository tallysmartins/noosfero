module PluginTestHelper

  def create_community name
    community = fast_create(Community)
    community.name = name
    community.identifier = name.to_slug
    community.save
    community
  end

  def create_software_info name, finality = "something", acronym = ""
    license = create_license_info("GPL")
    community = create_community(name)

    software_info = SoftwareInfo.new
    software_info.community = community
    software_info.license_info = license
    software_info.finality = finality
    software_info.acronym = acronym
    software_info.public_software = true
    software_info.save!

    software_info
  end

  def create_person name, email, password, password_confirmation, state, city
    user = create_user(
      name.to_slug,
      email,
      password,
      password_confirmation
    )

    user.person.state = state
    user.person.city = city

    user.save
    user.person
  end

  def create_user login, email, password, password_confirmation
    user = User.new

    user.login = login
    user.email = email
    user.password = password
    user.password_confirmation = password_confirmation

    user.save
    user
  end

  def create_license_info version, link = ""
    license = LicenseInfo.find_or_create_by_version(version)
    license.link = link
    license.save

    license
  end
end

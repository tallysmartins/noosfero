NUMBER_OF_SOFTWARES = 10

namespace :software do
  desc "Create sample softwares"
  task :create_sample_softwares => :environment do
    Environment.all.each do |env|
      if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("SoftwareCommunitiesPlugin")

        print "Creating softwares: "

        NUMBER_OF_SOFTWARES.times do |i|
          number = i < 10 ? "0#{i}" : "#{i}"
          software_name = "Software #{number}"
          create_software_info(software_name)
        end

        create_software_info("Ubuntu")
        create_software_info("Debian")
        create_software_info("Windows XP")
        create_software_info("Windows Vista")
        create_software_info("Windows 7")
        create_software_info("Windows 8")
        create_software_info("Disk Operating System", "DOS")
        create_software_info("Sublime")
        create_software_info("Vi IMproved", "Vim")
        create_software_info("Nano")
        create_software_info("Gedit")
        create_software_info("Firefox")
        create_software_info("InkScape")
        create_software_info("Eclipse")
        create_software_info("LibreOffice")
        create_software_info("Tetris")
        create_software_info("Mario")
        create_software_info("Pong")
        create_software_info("Sonic")
        create_software_info("Astah")
        create_software_info("Pokemom Red")
        create_software_info("Mass Effect")
        create_software_info("Deus EX")
        create_software_info("Dragon Age")

        puts ""
      end
    end
  end
end

def create_community(name)
  community = Community.new
  community.name = name
  community.save
  community
end

def create_software_info(name, acronym = "")
  community = create_community(name)
  software_info = SoftwareInfo.new
  software_info.community = community
  software_info.public_software = true
  software_info.acronym = acronym
  software_info.license_info = LicenseInfo.first

  if software_info.community.valid? && software_info.valid?
    print "."
    software_info.save
    software_info
  else
    print "F"
    nil
  end
end
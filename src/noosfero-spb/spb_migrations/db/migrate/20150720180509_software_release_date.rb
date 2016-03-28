class SoftwareReleaseDate < ActiveRecord::Migration
  def up
    softwares = SoftwareCommunitiesPlugin::SoftwareInfo.all
    softwares.each do |software|
      if software.community
        name = software.community.name.strip
        software.community.name = name
        software.community.save
      else
        software.destroy
      end
    end

    file = File.new("plugins/spb_migrations/files/date-communities.txt", "r")
    while (line = file.gets)
      result = line.split('|')
      software_name = result[2].gsub("/n", "")
      software = Community.find(:first, :conditions => ["lower(name) = ?", software_name.strip.downcase])
      software.created_at = Time.zone.parse(result[1]) if software
      if software && software.save
        print "."
      else
        print "F"
        puts software_name
      end
    end
    file.close
    puts ""
  end

  def down
    say "This can't be reverted"
  end
end

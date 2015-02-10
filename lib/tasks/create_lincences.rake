namespace :software do
  desc "Create software licences"

  task :create_licenses => :environment do
    Environment.all.each do |env|
      if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("MpogSoftwarePlugin")
        list_file = File.open "plugins/mpog_software/public/static/licences.txt", "r"

        version_or_link = 'version'
        can_save = true
        licence = nil

        print 'Creating Licenses: '
        list_file.each_line do |line|
          data = line.strip

          if data.length != 0
            if version_or_link == 'version'
              can_save = LicenseInfo.find_by_version(data) ? false : true
              licence = LicenseInfo::new :version => data
              version_or_link = 'link'
            elsif version_or_link == 'link'
              licence.link = data

              if can_save
                licence.save!
                print '.'
              else
                print 'F'
              end

              version_or_link = 'version'
            end
          end
        end
        puts ''

        list_file.close
      end
    end
  end
end
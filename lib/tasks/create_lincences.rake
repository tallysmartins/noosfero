namespace :software do
  desc "Create software licences"

  task :create_licences => :environment do
    Environment.all.each do |env|
      if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("MpogSoftwarePlugin")
        list_file = File.open "plugins/mpog_software/public/static/licences.txt", "r"

        name_or_link = 'version'
        licence = nil

        print 'Creating Licenses: '
        list_file.each_line do |line|
          data = line.strip

          if data.length != 0
            if version_or_link == 'version'
              licence = LicenseInfo::new :version => data

              version_or_link = 'link'
            elsif version_or_link == 'link'
              licence.link = data
              licence.save!
              print '.'

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
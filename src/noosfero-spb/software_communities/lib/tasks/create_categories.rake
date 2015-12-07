namespace :software do
  desc "Create software categories"
  task :create_categories => :environment do
    Environment.all.each do |env|
      if env.plugin_enabled?("SoftwareCommunitiesPlugin") or env.plugin_enabled?("SoftwareCommunities")
        print 'Creating categories: '
        software = env.categories.find_or_create_by_name(_("Software"))
        Category::SOFTWARE_CATEGORIES.each do |category_name|
          unless env.categories.find_by_name(category_name)
            print '.'
            Category.create(:name => category_name, :environment => env, :parent => software)
          else
            print 'F'
          end
        end
        puts ''
      end
    end
  end
end

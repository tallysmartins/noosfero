namespace :software do
  desc "Create software categories"
  task :create_categories => :environment do
    Environment.all.each do |env|
      if env.plugin_enabled?("SoftwareCommunitiesPlugin")
        print 'Creating categories: '
        software = Category.create(:name => _("Software"), :environment => env)
        Category::SOFTWARE_CATEGORIES.each do |category_name|
          print '.'
          Category.create(:name => category_name, :environment => env, :parent => software)
        end
        puts ''
      end
    end
  end
end

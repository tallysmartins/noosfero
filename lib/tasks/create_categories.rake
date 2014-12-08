namespace :software do
  desc "Create software categories"
  task :create_categories => :environment do
    Environment.all.each do |env|
      if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("MpogSoftwarePlugin")
        software = Category.create(:name => _("Software"), :environment => env)
        Category::SOFTWARE_CATEGORIES.each do |category_name|
          Category.create(:name => category_name, :environment => env, :parent => software)
        end
      end
    end
  end
end
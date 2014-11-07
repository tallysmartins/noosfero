namespace :software do
  desc "Create software categories"
  task :create_categories => :environment do
    Environment.all.each do |env|
      if env.plugin_enabled?("MpogSoftwarePlugin")
        software = Category.create!(:name => _("Software"), :environment => env)
        Category.create!(:name => _("Agriculture, Fisheries and Extraction"), :environment => env, :parent => software)
        Category.create!(:name => _("Science, Information and Communication"), :environment => env, :parent => software)
        Category.create!(:name => _("Economy and Finances"), :environment => env, :parent => software)
        Category.create!(:name => _("Public Administration"), :environment => env, :parent => software)
        Category.create!(:name => _("Habitation, Sanitation and Urbanism"), :environment => env, :parent => software)
        Category.create!(:name => _("Individual, Family and Society"), :environment => env, :parent => software)
        Category.create!(:name => _("Health"), :environment => env, :parent => software)
        Category.create!(:name => _("Social Welfare and Development"), :environment => env, :parent => software)
        Category.create!(:name => _("Defense and Security"), :environment => env, :parent => software)
        Category.create!(:name => _("Education"), :environment => env, :parent => software)
        Category.create!(:name => _("Government and Politics"), :environment => env, :parent => software)
        Category.create!(:name => _("Justice and Legislation"), :environment => env, :parent => software)
        Category.create!(:name => _("International Relationships"), :environment => env, :parent => software)
        Category.create!(:name => _("Transportation and Traffic"), :environment => env, :parent => software)
      end
    end
  end
end
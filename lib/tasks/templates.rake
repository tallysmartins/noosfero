namespace :templates do
  namespace :create do

    desc "Create new templates of software, intitution, person and community"
    task :all => :environment do
      Rake::Task["templates:create:institution"].invoke
      Rake::Task["templates:create:software"].invoke
      Rake::Task["templates:create:people"].invoke
      Rake::Task["templates:create:community"].invoke
    end

    desc "Create new templates of software"
    task :software => :environment do
      Environment.all.each do |env|
        if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("MpogSoftwarePlugin")
          puts "Software successfully created!"
        end
      end
    end

    desc "Create new templates of people"
    task :people => :environment do
      Environment.all.each do |env|
        if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("MpogSoftwarePlugin")
          person = Person.where(:identifier => "noosfero_person_template").first

          if person.nil?
            password = SecureRandom.hex(6)
            user = User.create!(:name => "People", :login => "people", :email => "person@template.noo", :password => password , :password_confirmation => password, :environment => env)
            person = user.person
          end

          person.layout_template = "leftbar"
          person.is_template = true

          box1 = person.boxes.where(:position => 1).first
          box1.blocks.destroy_all
          person.save!
          puts "Person successfully created!"

          institution_block = InstitutionsBlock.new
          institution_block.position = 4
          institution_block.save!
          box1.blocks << institution_block
          box1.save!
          puts "InstitutionBlock successfully added to person!"

          software_block = SoftwaresBlock.new
          software_block.position = 2
          software_block.save!
          box1.blocks << software_block
          box1.save!
          puts "SoftwaresBlock successfully added to person!"

          community_block = CommunitiesBlock.new
          community_block.position = 3
          community_block.save!
          box1.blocks << community_block
          box1.save!
          puts "CommunitiesBlock successfully added to person!"

          main_block = MainBlock.new
          main_block.position = 1
          main_block.save!
          box1.blocks << main_block
          box1.save!
          puts "MainBlock successfully added to person!"
        end
      end
    end


    desc "Create new templates of community"
    task :community => :environment do
      Environment.all.each do |env|
        if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("MpogSoftwarePlugin")
          puts "Community successfully created!"
        end
      end
    end

    desc "Create new templates of intitution"
    task :institution => :environment do
      Environment.all.each do |env|
        if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("MpogSoftwarePlugin")
          community = Community.create!(:name => "institution", :is_template => true, :moderated_articles => true, :environment => env)
          community.layout_template = "leftbar"

          box2 = community.boxes.where(:position => 2).first
          box1 = community.boxes.where(:position => 1).first
          box3 = community.boxes.where(:position => 3).first

          box2.blocks.destroy_all
          box1.blocks.destroy_all
          box3.blocks.destroy_all

          community.save!
          puts "Institution succesfully created!"

          members_block = MembersBlock.new
          members_block.limit = 16
          members_block.prioritize_profiles_with_image = true
          members_block.show_join_leave_button = false
          members_block.display_user = "all"
          members_block.language = "all"
          members_block.display = "always"
          members_block.position = 2
          members_block.save!
          box1.blocks << members_block
          box1.save!
          puts "MembersBlock successfully added to institution!"

          main_block = MainBlock.new
          main_block.position = 1
          main_block.save!
          box1.blocks << main_block
          box1.save!
          puts "MainBlock successfully added to institution!"
        end
      end
    end
  end


  desc "Destroy all templates created by this namespace"
  task :destroy => :environment do
    Environment.all.each do |env|
      if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("MpogSoftwarePlugin")
        Community["institution"].destroy
        puts "Institution template destoyed with success!"

        user = User["people"]
        if !user.nil?
          user.person.destroy
          user.destroy
          puts "Person template destroyed with success!"
        end
      end
    end
  end
end


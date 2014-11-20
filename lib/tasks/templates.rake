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
          puts "Person successfully created!"
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
          community = Community.create!(:name => "institution", :is_template => true, :moderated_articles => true)
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
          puts "MembersBlock successfully added!"
          
          
          main_block = MainBlock.new
          main_block.position = 1
          main_block.save!
          box1.blocks << main_block
          box1.save!
          puts "MainBlock successfully added!"
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
      end
    end
  end
end


#!/bin/env ruby
# encoding: utf-8

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
          software = Community["software"]

          if software.nil?
            software = Community.create!(:name => "Software", :identifier => "software")
          end

          software.layout_template = "default"
          software.is_template = true

          box1 = software.boxes.where(:position => 1).first
          box1.blocks.destroy_all
          software.save!

          #This box is going to be used for fixed blocks
          box2 = software.boxes.where(:position => 2).first
          box2.blocks.destroy_all
          software.save!

          box3 = software.boxes.where(:position => 3).first
          box3.blocks.destroy_all
          software.save!
          puts "Software successfully created!"

          categories_block = CategoriesAndTagsBlock.new
          categories_block.position = 4
          categories_block.display = "home_page_only"
          categories_block.save!
          box1.blocks << categories_block
          box1.save!
          puts "CategoriesAndTagsBlock successfully added to software!"
          
          main_block = MainBlock.new
          main_block.position = 3
          main_block.save!
          box1.blocks << main_block
          box1.save!

          download_block = DownloadBlock.new
          download_block.position = 2
          download_block.name = "Versão  X.Y"
          download_block.link = "#"
          download_block.software_description = "(Windows X, Ubuntu Y, Debian Z)"
          download_block.version_news = "#"
          download_block.display = "home_page_only"
          download_block.save!
          box1.blocks << download_block
          box1.save!
          puts "DownloadBlock successfully added to software!"

          software_information_block = SoftwareInformationBlock.new
          software_information_block.position = 1
          software_information_block.display = "home_page_only"
          software_information_block.save!
          box1.blocks << software_information_block
          box1.save!
          puts "SoftwareInformation successfully added to software!"

          puts "Software Main Box successfully created!"


          members_block = MembersBlock.new
          members_block.position = 6
          members_block.display = "except_home_page"
          members_block.name = ""
          members_block.address = ""
          members_block.visible_role = ""
          members_block.limit = 6
          members_block.prioritize_profiles_with_image = true
          members_block.show_join_leave_button = false
          members_block.title = "Equipe"
          
          members_block.save!
          box3.blocks << members_block
          box3.save!

          another_link_list_block = LinkListBlock.new
          another_link_list_block.position = 5
          another_link_list_block.display = "always"
          another_link_list_block.title = "Participe"
          links = [{"icon"=>"", "name"=>"Lista de E-mails", "address"=>"http://beta.softwarepublico.gov.br/archives/thread/", "target"=>"_self"}, {"icon"=>"no-icon", "name"=>"Comunidade", "address"=>"/profile/{profile}", "target"=>"_self"}, {"icon"=>"", "name"=>"Blog", "address"=>"/{profile}/blog", "target"=>"_self"}, {"icon"=>"no-icon", "name"=>"Fórum", "address"=>"/{profile}/forum-de-duvidas-e-discussao", "target"=>"_self"}, {"icon"=>"", "name"=>"Convide Amigos", "address"=>"/profile/{profile}/invite/friends", "target"=>"_self"}]
          
          another_link_list_block.save!
          box3.blocks << another_link_list_block
          another_link_list_block.update_attributes(:links => links)
          box3.save!
          puts "LinkListBlock successfully added to software!"


          repository_block = RepositoryBlock.new
          repository_block.position = 4
          repository_block.display = "always"
          repository_block.title = ""
          
          repository_block.save!
          box3.blocks << repository_block
          box3.save!
          puts "RepositoryBlock successfully added to software!"

          link_list_block = LinkListBlock.new
          link_list_block.position = 3
          link_list_block.display = "always"
          link_list_block.title = "Ajuda"
          link_list_block.links = [{"icon"=>"no-icon", "name"=>"Download de Versões", "address"=>"/{profile}/versoes", "target"=>"_self"}, {"icon"=>"", "name"=>"Pergutas Frequentes", "address"=>"/{profile}/perguntas-frequentes", "target"=>"_self"}, {"icon"=>"no-icon", "name"=>"README", "address"=>"/{profile}/versoes-estaveis", "target"=>"_self"}, {"icon"=>"", "name"=>"Como Instalar", "address"=>"/{profile}/tutorial-de-instalacao", "target"=>"_self"}, {"icon"=>"", "name"=>"Manuais", "address"=>"/{profile}/manuais-de-usuario", "target"=>"_self"}]
          
          link_list_block.save!
          box3.blocks << link_list_block
          link_list_block.update_attributes(:links => links)
          box3.save!
          puts "LinkListBlock successfully added to software!"

          profile_image_block = ProfileImageBlock.new
          profile_image_block.position = 2
          profile_image_block.display = "except_home_page"
          profile_image_block.show_name = false
          profile_image_block.save!
          
          box3.blocks << profile_image_block
          box3.save!
          puts "ProfileImageBlock successfully added to software!"
          
          statistics_block = StatisticsBlock.new
          statistics_block.position = 1
          statistics_block.display = "home_page_only"
          statistics_block.save!
          box3.blocks << statistics_block
          box3.save!
          puts "StatisticsBlock successfully added to software!"
          puts "MembersBlock successfully added to software!"
          puts "Software Box 3 successfully created!"

          puts "Software Template successfully created!"
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
        Community["institution"].destroy unless Community["institution"].nil?
        puts "Institution template destoyed with success!"

        Community["software"].destroy unless Community["software"].nil?
        puts "Software template destoyed with success!"

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


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

#Articles para software template
#[#<TinyMceArticle id: 38, name: "Perguntas Frequentes", slug: "perguntas-frequentes", path: "perguntas-frequentes", parent_id: nil, body: "<h3 style=\"text-align: justify;\">Pergunta 1</h3>\r\n<...", abstract: "", profile_id: 12, updated_at: "2014-10-29 21:11:14", created_at: "2014-10-29 21:00:27", last_changed_by_id: 5, version: 6, type: "TinyMceArticle", size: nil, content_type: nil, filename: nil, height: nil, width: nil, comments_count: 0, advertise: true, published: true, start_date: nil, end_date: nil, children_count: 0, accept_comments: true, reference_article_id: nil, setting: {:allow_members_to_edit=>false, :moderate_comments=>false, :display_hits=>true, :display_versions=>false, :author_name=>"adminuser"}, notify_comments: true, hits: 14, published_at: "2014-10-29 21:00:27", source: nil, highlighted: false, external_link: nil, thumbnails_processed: false, is_image: false, translation_of_id: nil, language: "pt", source_name: nil, license_id: 1, image_id: nil, position: nil, spam_comments_count: 0, author_id: 5, created_by_id: 5>,
#<Blog id: 32, name: "Blog", slug: "blog", path: "blog", parent_id: nil, body: nil, abstract: nil, profile_id: 12, updated_at: "2014-10-29 19:30:49", created_at: "2014-10-29 19:30:48", last_changed_by_id: nil, version: 1, type: "Blog", size: nil, content_type: nil, filename: nil, height: nil, width: nil, comments_count: 0, advertise: false, published: true, start_date: nil, end_date: nil, children_count: 1, accept_comments: true, reference_article_id: nil, setting: {}, notify_comments: true, hits: 7, published_at: "2014-10-17 16:43:25", source: nil, highlighted: false, external_link: nil, thumbnails_processed: false, is_image: false, translation_of_id: nil, language: nil, source_name: nil, license_id: nil, image_id: nil, position: nil, spam_comments_count: 0, author_id: nil, created_by_id: nil>,
#<RssFeed id: 33, name: "feed", slug: "feed", path: "blog/feed", parent_id: 32, body: {}, abstract: nil, profile_id: 12, updated_at: "2014-10-29 19:30:48", created_at: "2014-10-29 19:30:48", last_changed_by_id: nil, version: 1, type: "RssFeed", size: nil, content_type: nil, filename: nil, height: nil, width: nil, comments_count: 0, advertise: false, published: true, start_date: nil, end_date: nil, children_count: 0, accept_comments: true, reference_article_id: nil, setting: {}, notify_comments: true, hits: 0, published_at: "2014-10-29 19:30:48", source: nil, highlighted: false, external_link: nil, thumbnails_processed: false, is_image: false, translation_of_id: nil, language: nil, source_name: nil, license_id: nil, image_id: nil, position: nil, spam_comments_count: 0, author_id: nil, created_by_id: nil>,
#<Folder id: 35, name: "Manuais de Usuário", slug: "manuais-de-usuario", path: "manuais-de-usuario", parent_id: nil, body: "Pasta destinada para manuais de uso do Software", abstract: nil, profile_id: 12, updated_at: "2014-10-29 20:47:23", created_at: "2014-10-29 20:47:23", last_changed_by_id: 5, version: 1, type: "Folder", size: nil, content_type: nil, filename: nil, height: nil, width: nil, comments_count: 0, advertise: true, published: true, start_date: nil, end_date: nil, children_count: 0, accept_comments: false, reference_article_id: nil, setting: {:author_name=>"adminuser"}, notify_comments: true, hits: 5, published_at: "2014-10-29 20:47:23", source: nil, highlighted: false, external_link: nil, thumbnails_processed: false, is_image: false, translation_of_id: nil, language: nil, source_name: nil, license_id: 1, image_id: nil, position: nil, spam_comments_count: 0, author_id: 5, created_by_id: 5>,
#<Gallery id: 34, name: "Gallery", slug: "gallery", path: "gallery", parent_id: nil, body: nil, abstract: nil, profile_id: 12, updated_at: "2014-10-29 19:30:49", created_at: "2014-10-29 19:30:49", last_changed_by_id: nil, version: 1, type: "Gallery", size: nil, content_type: nil, filename: nil, height: nil, width: nil, comments_count: 0, advertise: false, published: true, start_date: nil, end_date: nil, children_count: 0, accept_comments: true, reference_article_id: nil, setting: {}, notify_comments: true, hits: 0, published_at: "2014-10-17 16:43:25", source: nil, highlighted: false, external_link: nil, thumbnails_processed: false, is_image: false, translation_of_id: nil, language: nil, source_name: nil, license_id: nil, image_id: nil, position: nil, spam_comments_count: 0, author_id: nil, created_by_id: nil>,
#<RssFeed id: 37, name: "feed", slug: "feed", path: "forum-de-duvidas-e-discussao/feed", parent_id: 36, body: {}, abstract: nil, profile_id: 12, updated_at: "2014-10-29 20:50:58", created_at: "2014-10-29 20:50:58", last_changed_by_id: nil, version: 1, type: "RssFeed", size: nil, content_type: nil, filename: nil, height: nil, width: nil, comments_count: 0, advertise: false, published: true, start_date: nil, end_date: nil, children_count: 0, accept_comments: true, reference_article_id: nil, setting: {}, notify_comments: true, hits: 0, published_at: "2014-10-29 20:50:58", source: nil, highlighted: false, external_link: nil, thumbnails_processed: false, is_image: false, translation_of_id: nil, language: nil, source_name: nil, license_id: nil, image_id: nil, position: nil, spam_comments_count: 0, author_id: nil, created_by_id: nil>,
#<Folder id: 39, name: "Versões Estáveis", slug: "versoes-estaveis", path: "versoes-estaveis", parent_id: nil, body: "Pasta com os pacotes para download das versões exis...", abstract: nil, profile_id: 12, updated_at: "2014-10-29 21:14:46", created_at: "2014-10-29 21:14:46", last_changed_by_id: 5, version: 1, type: "Folder", size: nil, content_type: nil, filename: nil, height: nil, width: nil, comments_count: 0, advertise: true, published: true, start_date: nil, end_date: nil, children_count: 0, accept_comments: false, reference_article_id: nil, setting: {:author_name=>"adminuser"}, notify_comments: true, hits: 11, published_at: "2014-10-29 21:14:46", source: nil, highlighted: false, external_link: nil, thumbnails_processed: false, is_image: false, translation_of_id: nil, language: nil, source_name: nil, license_id: 1, image_id: nil, position: nil, spam_comments_count: 0, author_id: 5, created_by_id: 5>,
#<Forum id: 36, name: "Fórum de Dúvidas e Discussão", slug: "forum-de-duvidas-e-discussao", path: "forum-de-duvidas-e-discussao", parent_id: nil, body: "Fórum destinado para dúvidas e discussões técnicas ...", abstract: nil, profile_id: 12, updated_at: "2014-10-29 20:50:58", created_at: "2014-10-29 20:50:58", last_changed_by_id: 5, version: 1, type: "Forum", size: nil, content_type: nil, filename: nil, height: nil, width: nil, comments_count: 0, advertise: true, published: true, start_date: nil, end_date: nil, children_count: 1, accept_comments: true, reference_article_id: nil, setting: {:posts_per_page=>10, :has_terms_of_use=>false, :terms_of_use=>"", :allow_members_to_edit=>false, :moderate_comments=>false, :allows_members_to_create_topics=>true, :author_name=>"adminuser"}, notify_comments: true, hits: 2, published_at: "2014-10-29 20:50:58", source: nil, highlighted: false, external_link: nil, thumbnails_processed: false, is_image: false, translation_of_id: nil, language: nil, source_name: nil, license_id: 1, image_id: nil, position: nil, spam_comments_count: 0, author_id: 5, created_by_id: 5>,
#<TinyMceArticle id: 40, name: "Tutorial de Instalação", slug: "tutorial-de-instalacao", path: "tutorial-de-instalacao", parent_id: nil, body: "<h2>Introdução</h2>\r\n<p>Texto introdutório à página...", abstract: "", profile_id: 12, updated_at: "2014-10-29 22:01:37", created_at: "2014-10-29 22:01:37", last_changed_by_id: 5, version: 1, type: "TinyMceArticle", size: nil, content_type: nil, filename: nil, height: nil, width: nil, comments_count: 0, advertise: true, published: true, start_date: nil, end_date: nil, children_count: 0, accept_comments: true, reference_article_id: nil, setting: {:allow_members_to_edit=>false, :moderate_comments=>false, :display_hits=>true, :display_versions=>false, :author_name=>"adminuser"}, notify_comments: true, hits: 7, published_at: "2014-10-29 22:01:37", source: nil, highlighted: false, external_link: nil, thumbnails_processed: false, is_image: false, translation_of_id: nil, language: "pt", source_name: nil, license_id: 1, image_id: nil, position: nil, spam_comments_count: 0, author_id: 5, created_by_id: 5>,
#<TinyMceArticle id: 42, name: "Versões", slug: "versoes", path: "versoes", parent_id: nil, body: "<p>Texto com detalhamento das mudanças que cada ver...", abstract: "", profile_id: 12, updated_at: "2014-10-30 19:17:10", created_at: "2014-10-30 18:55:08", last_changed_by_id: 5, version: 3, type: "TinyMceArticle", size: nil, content_type: nil, filename: nil, height: nil, width: nil, comments_count: 0, advertise: true, published: true, start_date: nil, end_date: nil, children_count: 0, accept_comments: true, reference_article_id: nil, setting: {:allow_members_to_edit=>false, :moderate_comments=>false, :display_hits=>true, :display_versions=>false, :author_name=>"adminuser"}, notify_comments: true, hits: 10, published_at: "2014-10-30 18:55:08", source: nil, highlighted: false, external_link: nil, thumbnails_processed: false, is_image: false, translation_of_id: nil, language: "pt", source_name: nil, license_id: 1, image_id: nil, position: nil, spam_comments_count: 0, author_id: 5, created_by_id: 5>,
#<TinyMceArticle id: 41, name: "Sobre o Software (INFORMAR NOME)", slug: "sobre-o-software-informar-nome", path: "sobre-o-software-informar-nome", parent_id: nil, body: "<p>Texto com explicação detalhada sobre o Software....", abstract: "", profile_id: 12, updated_at: "2014-10-30 13:57:05", created_at: "2014-10-30 13:54:40", last_changed_by_id: 5, version: 3, type: "TinyMceArticle", size: nil, content_type: nil, filename: nil, height: nil, width: nil, comments_count: 0, advertise: true, published: true, start_date: nil, end_date: nil, children_count: 0, accept_comments: false, reference_article_id: nil, setting: {:allow_members_to_edit=>false, :moderate_comments=>false, :display_hits=>true, :display_versions=>false, :author_name=>"adminuser"}, notify_comments: false, hits: 72, published_at: "2014-10-30 13:54:40", source: nil, highlighted: false, external_link: nil, thumbnails_processed: false, is_image: false, translation_of_id: nil, language: "pt", source_name: nil, license_id: 1, image_id: nil, position: nil, spam_comments_count: 0, author_id: 5, created_by_id: 5>]
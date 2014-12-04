#!/bin/env ruby
# encoding: utf-8

namespace :main_data do
  desc "Create the main community and its contents"
  task :populate => :environment do
    Rake::Task["main_data:community"].invoke
    Rake::Task["templates:create:all"].invoke
  end

  desc "Create the main community and its contents"
  task :all => :environment do
    Rake::Task["main_data:destroy"].invoke
    Rake::Task["templates:destroy"].invoke
    Rake::Task["software:create_categories"].invoke
    Rake::Task["main_data:populate"].invoke
  end

  desc "Create the main community"
  task :community => :environment do
    Environment.all.each do |env|
      if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("MpogSoftwarePlugin")
        identifier = "spb"
        community = Community.create!(:name => "SPB", :identifier => identifier)
        community.layout_template = "leftbar"

        box1 = community.boxes.where(:position => 1).first
        box2 = community.boxes.where(:position => 2).first
        box3 = community.boxes.where(:position => 3).first

        box1.blocks.destroy_all
        box2.blocks.destroy_all
        box3.blocks.destroy_all

        community.save!
        puts "SPB succesfully created!"

        main_block = MainBlock.new
        main_block.position = 1
        main_block.save!
        box1.blocks << main_block
        box1.save!
        puts "MainBlock successfully added to SPB!"

        generate_fixed_blocks(community)

        generate_article(community, Blog, {name: "Notícias", slug: "noticias", published: true, accept_comments: true, notify_comments: true, license_id: 1, body: "", accept_comments: false, posts_per_page: 5}, true)
        generate_article(community, TinyMceArticle, {name: "Sobre o Portal", slug: "sobre-o-portal", published: true, accept_comments: false, notify_comments: true, license_id: 1, body: "", accept_comments: false})
        generate_article(community, TinyMceArticle, {name: "Publique seu software", slug: "publique-seu-software", published: true, accept_comments: false, notify_comments: true, license_id: 1, body: "", accept_comments: false})
        generate_article(community, TinyMceArticle, {name: "Inicie um projeto", slug: "inicie-um-projeto", published: true, accept_comments: false, notify_comments: true, license_id: 1, body: "", accept_comments: false})
        generate_article(community, TinyMceArticle, {name: "Entenda o que é", slug: "entenda-o-que-e", published: true, accept_comments: false, notify_comments: true, license_id: 1, body: "", accept_comments: false})
        generate_article(community, TinyMceArticle, {name: "Ajuda", slug: "ajuda", published: true, accept_comments: false, notify_comments: true, license_id: 1, body: "", accept_comments: false})
      end
    end
  end

  desc "Create the home page blocks"
  task :home => :environment do
    Environment.all.each do |env|
      if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("MpogSoftwarePlugin")
        identifier = "spb"

        box2 = env.boxes.where(:position => 2).first
        box2.blocks.destroy_all

        generate_fixed_blocks(env)
      end
    end
  end

  desc "Destroy all main content created by this namespace"
  task :destroy => :environment do
    Environment.all.each do |env|
      if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("MpogSoftwarePlugin")
        Community["spb"].destroy unless Community["spb"].nil?
        puts "Main Community destoyed with success!"
      end
    end
  end

  private

  def generate_article(software, klass, params, home_page = false)
    article = klass.new(params)
    article.body = params[:body]

    software.articles << article
    if home_page
      software.home_page = article
    end

    software.save!

    puts "#{params[:name]} #{klass} successfully created!"
  end

  def generate_fixed_blocks(profile)
    identifier = "spb"

    box2 = profile.boxes.where(:position => 2).first

    first_link_list_block = LinkListBlock.new
    first_link_list_block.position = 3
    first_link_list_block.display = "always"
    first_link_list_block.title = "Portal do SPB"
    first_link_list_block.fixed = true
    first_link_list_block.save!

    first_link_list_block.links << {:icon => "no-icon", :name => "Sobre o Portal", :address => "/#{identifier}/sobre-o-portal", :target => "_self"}
    first_link_list_block.links << {:icon => "no-icon", :name => "Notícias", :address => "/#{identifier}/noticias", :target => "_self"}
    first_link_list_block.save!
    box2.blocks << first_link_list_block
    box2.save!
    puts "First LinkListBlock successfully added to software!"

    second_link_list_block = LinkListBlock.new
    second_link_list_block.position = 2
    second_link_list_block.display = "always"
    second_link_list_block.title = "Software Público"
    second_link_list_block.fixed = true
    second_link_list_block.save!

    second_link_list_block.links << {:icon => "no-icon", :name => "Entenda o que é", :address => "/#{identifier}/entenda-o-que-e", :target => "_self"}
    second_link_list_block.links << {:icon => "no-icon", :name => "Inicie um projeto", :address => "/#{identifier}/inicie-um-projeto", :target => "_self"}
    second_link_list_block.links << {:icon => "no-icon", :name => "Publique seu software", :address => "/#{identifier}/publique-seu-software", :target => "_self"}
    second_link_list_block.save!
    box2.blocks << second_link_list_block
    box2.save!
    puts "Second LinkListBlock successfully added to software!"

    third_link_list_block = LinkListBlock.new
    third_link_list_block.position = 1
    third_link_list_block.display = "always"
    third_link_list_block.title = ""
    third_link_list_block.fixed = true
    third_link_list_block.save!

    third_link_list_block.links << {:icon => "no-icon", :name => "Catálogo de Software Público", :address => "/search/software_infos", :target => "_self"}
    third_link_list_block.links << {:icon => "no-icon", :name => "Comunidades", :address => "/search/communities", :target => "_self"}
    third_link_list_block.links << {:icon => "no-icon", :name => "Ajuda", :address => "/#{identifier}/ajuda", :target => "_self"}

    third_link_list_block.save!
    box2.blocks << third_link_list_block
    box2.save!
    puts "Third LinkListBlock successfully added to software!"
  end
end

#!/bin/env ruby
# encoding: utf-8

namespace :main_data do
  desc "Create the main community and its contents"
  task :all => :environment do
    Rake::Task["main_data:community"].invoke
  end

  desc "Create the main community"
  task :community => :environment do
    Environment.all.each do |env|
      if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("MpogSoftwarePlugin")
        community = Community.create!(:name => "SPB", :identifier => "spb")
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

        first_link_list_block = LinkListBlock.new
        first_link_list_block.position = 3
        first_link_list_block.display = "always"
        first_link_list_block.title = "Portal do SPB"
        first_link_list_block.save!

        first_link_list_block.links << {:icon => "no-icon", :name => "Sobre o Portal", :address => "/{profile}/sobre-o-portal", :target => "_self"}
        first_link_list_block.links << {:icon => "no-icon", :name => "Notícias", :address => "/{profile}/noticias", :target => "_self"}
        first_link_list_block.save!
        box2.blocks << first_link_list_block
        box2.save!
        puts "First LinkListBlock successfully added to software!"

        second_link_list_block = LinkListBlock.new
        second_link_list_block.position = 2
        second_link_list_block.display = "always"
        second_link_list_block.title = "Software Público"
        second_link_list_block.save!

        second_link_list_block.links << {:icon => "no-icon", :name => "Entenda o que é", :address => "/{profile}/entenda-o-que-e", :target => "_self"}
        second_link_list_block.links << {:icon => "no-icon", :name => "Inicie um projeto", :address => "/{profile}/inicie-um-projeto", :target => "_self"}
        second_link_list_block.links << {:icon => "no-icon", :name => "Publique seu software", :address => "/{profile}/publique-seu-software", :target => "_self"}
        second_link_list_block.save!
        box2.blocks << second_link_list_block
        box2.save!
        puts "Second LinkListBlock successfully added to software!"

        third_link_list_block = LinkListBlock.new
        third_link_list_block.position = 1
        third_link_list_block.display = "always"
        third_link_list_block.title = ""
        third_link_list_block.save!

        third_link_list_block.links << {:icon => "no-icon", :name => "Catálogo de Software Público", :address => "#", :target => "_self"}
        third_link_list_block.links << {:icon => "no-icon", :name => "Comunidades", :address => "/search/communities", :target => "_self"}

        third_link_list_block.save!
        box2.blocks << third_link_list_block
        box2.save!
        puts "Third LinkListBlock successfully added to software!"
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
end

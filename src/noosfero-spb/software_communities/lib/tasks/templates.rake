#!/bin/env ruby
# encoding: utf-8

namespace :templates do
  namespace :create do

    desc "Create new templates of software, intitution, person and community"
    task :all => :environment do
      Rake::Task["templates:create:software"].invoke
    end

    desc "Create new templates of software"
    task :software => :environment do
      Environment.all.each do |env|
        if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("SoftwareCommunitiesPlugin")
          software = Community["software"]

          if software.nil?
            software = Community.create!(:name => "Software", :identifier => "software")
          end

          software.layout_template = "default"
          software.is_template = true
          software.save!

          puts "Software Template successfully created!"
        end
      end
    end
  end

  desc "Destroy all templates created by this namespace"
  task :destroy => :environment do
    Environment.all.each do |env|
      if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("SoftwareCommunitiesPlugin")
        Community["software"].destroy unless Community["software"].nil?
        puts "Software template destoyed with success!"
      end
    end
  end

  desc "Copy mail list article from template to all Communities"
  task :copy_mail_article => :environment do
    env = Environment.find_by_name("SPB") || Environment.default
    article = Profile['software'].articles.find_by_slug('como-participar-da-lista-de-discussao')
    Article.connection.execute("DELETE FROM articles WHERE slug='como-participar-da-lista-de-discussao' AND id NOT IN (#{article.id})")
    puts "Copying article #{article.title}: " if article.present?
    if article.present?
      env.communities.find_each do |community|
        next unless community.software?
        a_copy = community.articles.find_by_slug('como-participar-da-lista-de-discussao') || article.copy_without_save
        a_copy.profile = community
        a_copy.save
        box =  community.boxes.detect {|x| x.blocks.find_by_title("Participe") } if community.present?
        block = box.blocks.find_by_title("Participe") if box.present?
        link = block.links.detect { |l| l["name"] == "Listas de discussão" } if block.present?
        link["address"] = "/{profile}/#{a_copy.path}" if link.present?
        block.save if block.present?
        print "."
      end
    else
      puts "Article not found"
    end
  end
end

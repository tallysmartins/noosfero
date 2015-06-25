#!/bin/env ruby
# encoding: utf-8

namespace :main_data do
  desc "Create the main community and its contents"
  task :populate => :environment do
    Rake::Task["templates:create:all"].invoke
    Rake::Task["software:create_licenses"].invoke
    Rake::Task["software:create_categories"].invoke
    Rake::Task["software:create_sample_softwares"].invoke
  end

  desc "Create the main community and its contents"
  task :all => :environment do
    Rake::Task["templates:destroy"].invoke
    Rake::Task["main_data:populate"].invoke
  end
end

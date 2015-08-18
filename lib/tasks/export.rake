require 'csv'

namespace :export do
  namespace :catalog do
    desc "Export all softwares to CSV"
    task :csv => :environment do
      Environment.all.each do |env|
        if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("SoftwareCommunitiesPlugin")
          CSV.open('softwares.csv', 'w') do |csv|
            csv << [
              "id",
              "community_id",
              "identifier",
              "name",
              "finality",
              "acronym",
              "created_at",
              "image_filename",
              "home_page_name",
              "home_page_slug",
              "home_page_path",
              "home_page_body",
              "home_page_abstract",
              "home_page_published_at"
            ]

            SoftwareInfo.all.each do |software|
              csv << [
                software.id,
                software.community.id,
                software.community.identifier,
                software.community.name,
                software.finality,
                software.acronym,
                software.community.created_at,
                (software.community.image.nil? ? nil : software.community.image.filename),
                (software.community.home_page.nil? ? nil : software.community.home_page.name),
                (software.community.home_page.nil? ? nil : software.community.home_page.slug),
                (software.community.home_page.nil? ? nil : software.community.home_page.path),
                (software.community.home_page.nil? ? nil : software.community.home_page.body),
                (software.community.home_page.nil? ? nil : software.community.home_page.abstract),
                (software.community.home_page.nil? ? nil : software.community.home_page.published_at),
              ]
            end
          end

          CSV.open('categories.csv', 'w') do |csv|
            csv << [
              "id",
              "name",
              "path",
            ]

            Category.all.each do |category|
              csv << [
                category.id,
                category.name,
                category.path,
              ]
            end
          end

          CSV.open('software_categories.csv', 'w') do |csv|
            csv << [
              "software_id",
              "category_id"
            ]

            SoftwareInfo.all.each do |software|
              software.community.categories.each do |category|
                csv << [
                  software.id,
                  category.id
                ]
              end
            end
          end
        end
      end
    end
  end
end
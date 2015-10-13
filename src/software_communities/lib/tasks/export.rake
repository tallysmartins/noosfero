require 'csv'

namespace :export do
  namespace :catalog do
    desc "Export all softwares to CSV"
    task :csv => :environment do
      Environment.all.each do |env|
        if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("SoftwareCommunitiesPlugin")
          softwares_to_csv
          categories_to_csv
          software_categories_to_csv

          compress_files
        end
      end
    end
  end

  def softwares_to_csv
    print "Exporting softwares to softwares.csv: "

    CSV.open('/tmp/softwares.csv', 'w') do |csv|
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
        if software.community
          begin
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

            print '.'
          rescue
            print 'F'
          end
        end
      end
    end

    print "\n"
  end

  def categories_to_csv
    print "Exporting categories to categories.csv: "

    CSV.open('/tmp/categories.csv', 'w') do |csv|
      csv << [
        "id",
        "name",
        "path",
      ]

      Category.all.each do |category|
        begin
          csv << [
            category.id,
            category.name,
            category.path,
          ]

          print '.'
        rescue
          print 'F'
        end
      end
    end

    print "\n"
  end

  def software_categories_to_csv
    print "Exporting software and categories relation to software_categories.csv: "
    CSV.open('/tmp/software_categories.csv', 'w') do |csv|
      csv << [
        "software_id",
        "category_id"
      ]

      SoftwareInfo.all.each do |software|
        if software.community
          software.community.categories.each do |category|
            begin
              csv << [
                software.id,
                category.id
              ]

              print '.'
            rescue
              print 'F'
            end
          end
        end
      end
    end

    print "\n"
  end

  def compress_files
    `cd /tmp/ && tar -zcvf software_catalog_csvs.tar.gz softwares.csv categories.csv software_categories.csv`

    `cd /tmp/ && rm softwares.csv categories.csv software_categories.csv`
  end
end
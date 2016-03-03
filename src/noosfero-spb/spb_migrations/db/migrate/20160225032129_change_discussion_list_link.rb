# encoding: UTF-8
class ChangeDiscussionListLink < ActiveRecord::Migration
  def up
    env = Environment.find_by_name("SPB") || Environment.default
    modified_blocks = []
    modified_links = []
      env.communities.find_each do |community|
        next unless community.software? || community.identifier == "software"
        box =  community.boxes.detect {|x| x.blocks.find_by_title("Participe") } if community.present?
        block = box.blocks.find_by_title("Participe") if box.present?
        if block.present?
          link = block.links.detect { |l|
                                      l["name"] == "Listas de discussão" ||
                                      l["name"] == "Lista de E-mails"
                                    }
          if link.present?
            link["address"] = "/../archives/mailinglist/{profile}?order=rating" if link.present?
            link["name"] = "Listas de discussão"
            block.save
            print "."
          else
            modified_links << community.identifier
            print "-"
          end
        else
          modified_blocks << community.identifier
          print "x"
        end
      end
      puts "\n****Softwares where block was not found:", modified_blocks.sort if modified_blocks.present?
      puts "\n****Softwares where link was not found: ", modified_links.sort if modified_links.present?
  end

  def down
    say "This migration can't be reverted"
  end
end

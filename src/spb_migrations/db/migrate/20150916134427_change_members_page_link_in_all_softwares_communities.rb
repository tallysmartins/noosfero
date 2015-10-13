# encoding: utf-8

class ChangeMembersPageLinkInAllSoftwaresCommunities < ActiveRecord::Migration
  def up
    Community.joins(:software_info).each do |software_community|
      collaboration_block = Block.joins(:box).where("boxes.owner_id = ? AND blocks.type = ? AND blocks.title = ?", software_community.id, "LinkListBlock", "Colaboração").readonly(false).first

      if collaboration_block
        collaboration_block.links.each do |link|
          link["address"] = "/profile/#{software_community.identifier}/members" if link["name"] == "Usuários"
        end
        collaboration_block.save!
        print "."
      end
    end

    puts ""
  end

  def down
    say "This can't be reverted"
  end
end


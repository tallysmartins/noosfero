class AddCommunityBlockInPlaceOfProfileImageBlock < ActiveRecord::Migration
  def up
    software_template = Community['software']

    if software_template
      software_area_two = software_template.boxes.find_by_position 2

      community_block_template = CommunityBlock.new :mirror => true, :move_modes => "none", :edit_modes => "none"
      community_block_template.settings[:fixed] = true
      community_block_template.display = "except_home_page"
      community_block_template.save!
      print "."

      software_area_two.blocks << community_block_template
      software_area_two.save!
      print "."

      profile_image_block = software_area_two.blocks.find_by_type("ProfileImageBlock")
      if !profile_image_block.nil?
        community_block_template.position = profile_image_block.position
        community_block_template.save!
        print "."

        profile_image_block.destroy
        print "."
      end
    end

    Community.joins(:software_info).each do |software_community|
      software_area_two = software_community.boxes.find_by_position 2
      print "."

      community_block = CommunityBlock.new :mirror => true, :move_modes => "none", :edit_modes => "none"
      community_block.settings[:fixed] = true
      community_block.display = "except_home_page"
      community_block.mirror_block_id = community_block_template.id if community_block_template
      community_block.save!
      print "."

      software_area_two.blocks << community_block
      software_area_two.save!
      print "."

      profile_image_block = software_area_two.blocks.find_by_type("ProfileImageBlock")
      if !profile_image_block.nil?
        community_block.position = profile_image_block.position
        community_block.save!
        print "."

        profile_image_block.destroy
        print "."

        # Put all link list blocks to behind
        link_list_blocks = software_area_two.blocks.where(:type=>"LinkListBlock", :position=>1)
        link_list_blocks.update_all :position => 3
      end
    end

    puts ""
  end

  def down
    say "This can't be reverted"
  end
end

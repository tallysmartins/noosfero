class AddCommunitiesRatingsBlockToAllSoftwaresCommunities < ActiveRecord::Migration
  def up
    software_template = Community["software"]
    if software_template
      software_area_one = software_template.boxes.find_by_position 1

      template_ratings_block = CommunitiesRatingsBlock.new :mirror => true, :move_modes => "none", :edit_modes => "none"
      template_ratings_block.settings[:fixed] = true
      template_ratings_block.display = "home_page_only"
      template_ratings_block.save!
      print "."

      software_area_one.blocks << template_ratings_block
      software_area_one.save!
      print "."

      # Puts the ratings block as the last one on area one
      last_block_position = software_area_one.blocks.order(:position).last.position
      template_ratings_block.position = last_block_position + 1
      template_ratings_block.save!
      print "."
    end

    Community.joins(:software_info).each do |software_community|
      software_area_one = software_community.boxes.find_by_position 1
      print "."

      ratings_block = CommunitiesRatingsBlock.new :move_modes => "none", :edit_modes => "none"
      ratings_block.settings[:fixed] = true
      ratings_block.display = "home_page_only"
      ratings_block.mirror_block_id = template_ratings_block.id
      ratings_block.save!
      print "."

      software_area_one.blocks << ratings_block
      software_area_one.save!
      print "."

      # Puts the ratings block as the last one on area one
      last_block_position = software_area_one.blocks.order(:position).last.position
      ratings_block.position = last_block_position + 1
      ratings_block.save!
      print "."
    end

    puts ""
  end

  def down
    say "This can't be reverted"
  end
end

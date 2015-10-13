class AddWikiBlockToAllSoftwaresCommunities < ActiveRecord::Migration
  def up
    software_template = Community["software"]

    if software_template
      software_area_two = software_template.boxes.find_by_position 2

      wiki_block_template = WikiBlock.new :mirror => true, :move_modes => "none", :edit_modes => "none"
      wiki_block_template.settings[:fixed] = true
      wiki_block_template.save!
      print "."

      software_area_two.blocks << wiki_block_template
      software_area_two.save!
      print "."

      # Puts the ratings block as the last one on area one
      repository_block = software_area_two.blocks.find_by_type("RepositoryBlock")
      if !repository_block.nil?
        wiki_block_template.position = repository_block.position + 1
        wiki_block_template.save!
        print "."
      end
    end

    Community.joins(:software_info).each do |software_community|
      software_area_two = software_community.boxes.find_by_position 2
      print "."

      wiki_block = WikiBlock.new :move_modes => "none", :edit_modes => "none"
      wiki_block.settings[:fixed] = true
      wiki_block.mirror_block_id = wiki_block_template.id
      wiki_block.save!
      print "."

      software_area_two.blocks << wiki_block
      software_area_two.save!
      print "."

      repository_block = software_area_two.blocks.find_by_type("RepositoryBlock")
      if !repository_block.nil?
        wiki_block.position = repository_block.position
        wiki_block.save!
        print "."
      end
    end

    puts ""
  end

  def down
    say "This can't be reverted"
  end
end

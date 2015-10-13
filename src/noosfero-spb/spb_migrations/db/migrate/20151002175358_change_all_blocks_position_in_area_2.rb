class ChangeAllBlocksPositionInArea2 < ActiveRecord::Migration
  def up
    software_template = Community['software']
    print "."

    if software_template
      software_area_two = software_template.boxes.find_by_position 2
      print "."

      change_blocks_position software_area_two.blocks if software_area_two
    end

    Community.joins(:software_info).each do |software_community|
      software_area_two = software_community.boxes.find_by_position 2
      print "."

      change_blocks_position software_area_two.blocks if software_area_two
    end

    puts ""
  end

  def down
    say "This can't be reverted"
  end

  private

  def change_blocks_position blocks
    blocks.each do |block|
      block.position = get_block_position(block)
      block.save!
      print "."
    end
  end

  def get_block_position block
    case block.type
    when "CommunityBlock"
      1
    when "StatisticBlock"
      2
    when "RepositoryBlock"
      4
    when "WikiBlock"
      5
    when "MembersBlock"
      7
    when "LinkListBlock"
      if block.title == "Ajuda"
        3
      else
        6
      end
    else
      8
    end
  end
end


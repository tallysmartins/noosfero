class SwapSoftwaresBlocksBetweenAreas2And3 < ActiveRecord::Migration
  def up
    swap_software_blocks_between_areas_2_and_3
  end

  def down
    swap_software_blocks_between_areas_2_and_3
  end

  def swap_software_blocks_between_areas_2_and_3
    Community.joins(:software_info).each do |software_community|
      print "."

      # Get areas 2 and 3
      box_area_two = software_community.boxes.find_by_position 2
      box_area_three = software_community.boxes.find_by_position 3

      # Get all ids of blocks from areas 2 and 3
      blocks_ids_from_area_two = box_area_two.blocks.select(:id).map(&:id)
      blocks_ids_from_area_three = box_area_three.blocks.select(:id).map(&:id)

      # Swap blocks from area 2 to 3
      Block.update_all({:box_id=>box_area_three.id}, ["id IN (?)", blocks_ids_from_area_two])

      # Swap blocks from area 3 to 2
      Block.update_all({:box_id=>box_area_two.id}, ["id IN (?)", blocks_ids_from_area_three])
    end

    puts ""
  end
end


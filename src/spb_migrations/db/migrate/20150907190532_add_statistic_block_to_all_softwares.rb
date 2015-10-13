class AddStatisticBlockToAllSoftwares < ActiveRecord::Migration
  def up
    software_template = Community["software"]

    if software_template
      software_area_two = software_template.boxes.find_by_position 2

      statistic_block_template = StatisticBlock.new :mirror => true, :move_modes => "none", :edit_modes => "none"
      statistic_block_template.settings[:fixed] = true
      statistic_block_template.display = "home_page_only"
      statistic_block_template.save!
      print "."

      software_area_two.blocks << statistic_block_template
      software_area_two.save!
      print "."

      # Puts the ratings block as the last one on area one
      first_block_position = software_area_two.blocks.order(:position).first.position
      statistic_block_template.position = first_block_position + 1
      statistic_block_template.save!
      print "."
    end

    Community.joins(:software_info).each do |software_community|
      software_area_two = software_community.boxes.find_by_position 2
      print "."

      statistic_block = StatisticBlock.new :move_modes => "none", :edit_modes => "none"
      statistic_block.settings[:fixed] = true
      statistic_block.display = "home_page_only"
      statistic_block.mirror_block_id = statistic_block_template.id
      statistic_block.save!
      print "."

      software_area_two.blocks << statistic_block
      software_area_two.save!
      print "."

      # Puts the ratings block as the last one on area one
      first_block_position = software_area_two.blocks.order(:position).first.position
      statistic_block.position = first_block_position + 1
      statistic_block.save!
      print "."
    end

    puts ""
  end

  def down
    say "This can't be reverted"
  end
end

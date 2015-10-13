class AddSoftwareTabDataBlockToAllSoftwares < ActiveRecord::Migration
  def up
    software_template = Community["software"]
    if software_template
      software_area_one = software_template.boxes.find_by_position 1

      template_soft_tab_block = SoftwareTabDataBlock.new :mirror => true, :move_modes => "none", :edit_modes => "none"
      template_soft_tab_block.settings[:fixed] = true
      template_soft_tab_block.display = "except_home_page"
      template_soft_tab_block.save!
      print "."

      software_area_one.blocks << template_soft_tab_block
      software_area_one.save!
      print "."

      # Puts the ratings block as the last one on area one
      last_block_position = software_area_one.blocks.order(:position).last.position
      template_soft_tab_block.position = last_block_position + 1
      template_soft_tab_block.save!
      print "."
    end

    Community.joins(:software_info).each do |software_community|
      software_area_one = software_community.boxes.find_by_position 1
      print "."

      soft_tab_block = SoftwareTabDataBlock.new :move_modes => "none", :edit_modes => "none"
      soft_tab_block.settings[:fixed] = true
      soft_tab_block.display = "except_home_page"
      soft_tab_block.mirror_block_id = template_soft_tab_block.id
      soft_tab_block.save!
      print "."

      software_area_one.blocks << soft_tab_block
      software_area_one.save!
      print "."

      # Puts the ratings block as the last one on area one
      last_block_position = software_area_one.blocks.order(:position).last.position
      soft_tab_block.position = last_block_position + 1
      soft_tab_block.save!
      print "."
    end

    puts ""
  end

  def down
    say "This can't be reverted"
  end
end

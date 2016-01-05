#encoding: utf-8

namespace :software do
  desc "Create missing blocks in software and templates"
  task :box_organize => :environment do
    software_template = Community["software"]
    next unless software_template.is_template?

    existing_blocks = Block.count

    puts "Last block id: #{Block.last.id}"
    puts "Create template boxes:"

    software_area_four = software_template.boxes.find_by_position 4
    four = false

    if software_area_four.blocks.first.class != BreadcrumbsPlugin::ContentBreadcrumbsBlock
      template_breadcrumbs_block = BreadcrumbsPlugin::ContentBreadcrumbsBlock.new :mirror => true, :move_modes => "none", :edit_modes => "none"
      template_breadcrumbs_block.settings[:fixed] = true
      template_breadcrumbs_block.display = "always"
      template_breadcrumbs_block.save!

      software_area_four.blocks << template_breadcrumbs_block
      software_area_four.save!

      pos = software_area_four.blocks.order(:position).first.position
      change_block_pos(software_area_four, template_breadcrumbs_block, pos)
      print "."

      four = true
    end
    ############################################################################

    software_area_two = software_template.boxes.find_by_position 2
    two = false

    if software_area_two.blocks.last.class != SoftwareEventsBlock
      template_software_events = SoftwareEventsBlock.new :mirror => true, :move_modes => "none", :edit_modes => "all"
      template_software_events.title = "Outros Eventos"
      template_software_events.display = "except_home_page"
      template_software_events.save!

      software_area_two.blocks << template_software_events
      software_area_two.save!

      pos = software_area_two.blocks.order(:position).last.position
      change_block_pos(software_area_four, template_software_events, pos+1)
      print "."

      two = true
    end
    ############################################################################

    software_area_one = software_template.boxes.find_by_position 1
    one = false

    if software_area_one.blocks[-2].class != SoftwareEventsBlock
      second_template_software_events = SoftwareEventsBlock.new :mirror => true, :move_modes => "none", :edit_modes => "all"
      second_template_software_events.display = "except_home_page"
      second_template_software_events.save!

      software_area_one.blocks << second_template_software_events
      software_area_one.save!

      pos = software_area_one.blocks.order(:position).last.position
      change_block_pos(software_area_one, second_template_software_events, pos)
      print "."
      one = true
    end


    puts "\nCreate software community boxes:"
    Community.joins(:software_info).each do |software_community|
      software_area_four = software_community.boxes.find_by_position 4

      if four && software_area_four.blocks.first.class != BreadcrumbsPlugin::ContentBreadcrumbsBlock
        breadcrumbs_block = BreadcrumbsPlugin::ContentBreadcrumbsBlock.new :mirror => true, :move_modes => "none", :edit_modes => "none"
        breadcrumbs_block.settings[:fixed] = true
        breadcrumbs_block.display = "always"
        breadcrumbs_block.mirror_block_id = template_breadcrumbs_block.id
        breadcrumbs_block.save!

        software_area_four.blocks << breadcrumbs_block
        software_area_four.save!

        # Puts the breadcrumbs as the first one on area four
        pos = software_area_four.blocks.order(:position).first.position
        change_block_pos(software_area_four, breadcrumbs_block, pos)
        print "."

      end
      ############################################################################

      software_area_two = software_community.boxes.find_by_position 2

      if two
        software_events = SoftwareEventsBlock.new :mirror => true, :move_modes => "none", :edit_modes => "all"
        software_events.title = "Outros Eventos"
        software_events.display = "except_home_page"
        software_events.mirror_block_id = template_software_events.id
        software_events.save!

        software_area_two.blocks << software_events
        software_area_two.save!

        # Puts the breadcrumbs as the first one on area four
        pos = software_area_two.blocks.order(:position).last.position
        change_block_pos(software_area_four, software_events, pos+1)
        print "."
      end
      ############################################################################

      software_area_one = software_community.boxes.find_by_position 1

      if one
        software_events = SoftwareEventsBlock.new :mirror => true, :move_modes => "none", :edit_modes => "all"
        software_events.display = "except_home_page"
        software_events.mirror_block_id = second_template_software_events.id
        software_events.save!

        software_area_one.blocks << software_events
        software_area_one.save!

        # Puts the breadcrumbs as the first one on area four
        pos = software_area_one.blocks.order(:position).last.position
        change_block_pos(software_area_one, software_events, pos)
        print "."
      end
    end

    print "\n"

    puts "Created blocks: #{Block.count - existing_blocks}"
  end

  def change_block_pos(box, block, pos)
    box.blocks.each do |b|
      if b.position >= pos
        b.position += 1
        b.save
      end
    end

    block.position = pos
    block.save
  end
end


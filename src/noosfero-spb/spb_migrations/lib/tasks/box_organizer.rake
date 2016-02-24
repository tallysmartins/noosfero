#encoding: utf-8

namespace :software do
  desc "Adds breadcrumbs and events block to softwares"
  task :boxes_all => [:clear_breadcrumbs_and_event_blocks, :fix_blocks_position, :box_organize]

  desc "Delete breadcrumbs and events block from softwares"
  task :clear_breadcrumbs_and_event_blocks => :environment do
    env = Environment.find_by_name("SPB")
    if env.present?
      env.communities.find_each do |c|
        if c.software? || c.identifier == "software"
          breadcrumbs = c.blocks.select{ |bl|
                          bl.type == "BreadcrumbsPlugin::ContentBreadcrumbsBlock" ||
                          bl.type == "SoftwareEventsBlock"
                        }

          breadcrumbs.each do |b|
            b.destroy
            print "."
          end
        end
      end
    end
  end

  desc "Fixes all blocks position in all softwares"
  task :fix_blocks_position => :environment do
    env = Environment.find_by_name("SPB")
    if env.present?
      env.communities.find_each do |c|
        c.boxes.each do |box|
          n = box.blocks.count
          pos = 1.upto(n).to_a
          blocks_ids = box.blocks.map(&:id)
          pos.each do |p|
            ActiveRecord::Migration.execute("UPDATE blocks SET position = #{p} WHERE id = #{blocks_ids[p-1]}")
          end
        end
      end
    end
  end

  desc "Create missing blocks in software and templates"
  task :box_organize => :environment do
    env = Environment.find_by_name("SPB")
    software_template = env.communities.find_by_identifier "software"

    puts "Searching for software template and environment..."
    return if software_template.nil? || env.nil?

    puts "Creating template boxes:"
    template_breadcrumbs = nil
    box_one = software_template.boxes.find_by_position 1

    unless box_has_block_of_type?(box_one, "BreadcrumbsPlugin::ContentBreadcrumbsBlock")
      template_breadcrumbs = BreadcrumbsPlugin::ContentBreadcrumbsBlock.new(
                              :mirror => true,
                              :move_modes => "none",
                              :edit_modes => "none")
      template_breadcrumbs.settings[:fixed] = true
      template_breadcrumbs.display = "always"
      template_breadcrumbs.save!

      box_one.blocks << template_breadcrumbs
      box_one.save!

      pos = box_one.blocks.order(:position).first.position
      change_block_pos(box_one, template_breadcrumbs, pos)
      print "."
    end
    ############################################################################

    template_software_events_1 = nil

    unless box_has_block_of_type?(box_one, "SoftwareEventsBlock")
      template_software_events_1 = SoftwareEventsBlock.new(
                                    :mirror => true,
                                    :move_modes => "none",
                                    :edit_modes => "none")
      template_software_events_1.display = "except_home_page"
      template_software_events_1.save!

      box_one.blocks << template_software_events_1
      box_one.save!

      pos = box_one.blocks.detect { |bl| bl.type == "SoftwareTabDataBlock"}.position

      change_block_pos(box_one, template_software_events_1, pos)
      print "."
    end
    ############################################################################

    template_software_events_2 = nil
    box_two = software_template.boxes.find_by_position 2

    unless box_has_block_of_type?(box_two, "SoftwareEventsBlock")
      pos = box_two.blocks.order(:position).last.position

      template_software_events_2 = SoftwareEventsBlock.new(
                                    :mirror => true,
                                    :move_modes => "none",
                                    :edit_modes => "none",
                                    :amount_of_events => 5)
      template_software_events_2.title = "Outros Eventos"
      template_software_events_2.display = "except_home_page"
      template_software_events_2.save

      box_two.blocks << template_software_events_2
      box_two.save!

      pos = box_two.blocks.order(:position).last.position
      change_block_pos(box_two, template_software_events_2, pos+1)
      print "."
    end
    ############################################################################


    puts "\nCreate software community boxes:"
    env.communities.each do |community|
      next unless community.software?
      box_one = community.boxes.find_by_position 1

      unless box_has_block_of_type?(box_one, "BreadcrumbsPlugin::ContentBreadcrumbsBlock")
        breadcrumbs_block = BreadcrumbsPlugin::ContentBreadcrumbsBlock.new(
                              :move_modes => "none", :edit_modes => "none"
                            )
        breadcrumbs_block.settings[:fixed] = true
        breadcrumbs_block.display = "always"
        breadcrumbs_block.mirror_block_id = template_breadcrumbs.id if template_breadcrumbs
        breadcrumbs_block.save!

        box_one.blocks << breadcrumbs_block
        box_one.save!

        # Puts the breadcrumbs as the first one on box one
        pos = box_one.blocks.order(:position).first.position
        change_block_pos(box_one, breadcrumbs_block, pos)
        print "."

      end

      ############################################################################
      unless box_has_block_of_type?(box_one, "SoftwareEventsBlock")
        software_events_block_1 = SoftwareEventsBlock.new(
                                    :move_modes => "none",
                                    :edit_modes => "none")
        software_events_block_1.display = "except_home_page"
        software_events_block_1.mirror_block_id = template_software_events_1.id if template_software_events_1
        software_events_block_1.save!

        box_one.blocks << software_events_block_1
        box_one.save!

        pos = box_one.blocks.detect { |bl| bl.type == "SoftwareTabDataBlock"}.position
        # Puts the software events block above Software Tab Data on area one
        change_block_pos(box_one, software_events_block_1, pos)
        print "."
      end

      ############################################################################
      box_two = community.boxes.find_by_position 2

      unless box_has_block_of_type?(box_two, "SoftwareEventsBlock")
        software_events_block_2 = SoftwareEventsBlock.new(
                                    :move_modes => "none",
                                    :edit_modes => "none",
                                    :amount_of_events => 5)

        software_events_block_2.title = "Outros Eventos"
        software_events_block_2.display = "except_home_page"
        software_events_block_2.mirror_block_id = template_software_events_2.id if template_software_events_2
        software_events_block_2.save!

        box_two.blocks << software_events_block_2
        box_two.save!

        # Puts the software events block as the last one on area two
        pos = box_two.blocks.order(:position).last.position
        change_block_pos(box_two, software_events_block_2, pos+1)
        print "."
      end
      ############################################################################

    end

    puts "All blocks  created with success."
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

  def box_has_block_of_type?(box, block_type)
   blocks = box.blocks.detect {|bl| bl.type == block_type}
   blocks.present?
  end
end


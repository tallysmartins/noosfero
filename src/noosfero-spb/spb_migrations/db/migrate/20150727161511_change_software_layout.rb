class ChangeSoftwareLayout < ActiveRecord::Migration
  def up
    software_template = Community["software"]
    if software_template
      change_layout(software_template)
    end

    softwares = SoftwareCommunitiesPlugin::SoftwareInfo.all
    softwares.each do |software|
      if software.community
        change_layout(software.community)
      end
    end
    puts ""
  end

  def down
  end

  def change_layout(community)
    community.layout_template = "lefttopright"
    print "." if community.save
    boxToMove = community.boxes.where(:position => 1).first
    blockToMove = boxToMove.blocks.where(:type => "SoftwareInformationBlock").first
    if blockToMove
      newBox = community.boxes.where(:position => 4).first
      blockToMove.box = newBox
      print "." if blockToMove.save
    end
  end
end

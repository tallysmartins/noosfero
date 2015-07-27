class ChangeSoftwareLayout < ActiveRecord::Migration
  def up
    softwares = SoftwareInfo.all
    softwares.each do |software|
      software.community.layout_template = "lefttopright"
      print "." if software.community.save
      boxToMove = software.community.boxes.where(:position => 1).first
      blockToMove = boxToMove.blocks.where(:type => "SoftwareInformationBlock").first
      if blockToMove
        newBox = software.community.boxes.where(:position => 4).first
        blockToMove.box = newBox
        print "." if blockToMove.save
      end
    end
  end

  def down
  end
end

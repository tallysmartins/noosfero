class ChangeBlocksMirrorOption < ActiveRecord::Migration
  def up
    blocks = Block.where(:type => LinkListBlock)
    institution = Community["institution"]
    software = Community["software"]

    boxTemplateInstitution = institution.boxes.where(:position => 2).first

    boxTemplateInstitution.blocks.each do |block|
      block.mirror = true
      print "." if block.save
    end

    boxTemplateSoftware = software.boxes.where(:position => 2).first

    boxTemplateSoftware.blocks.each do |block|
      block.mirror = true
      print "." if block.save
    end

    blocks.each do |block|
      if !(block.owner.class == Environment) && block.owner.organization? && !block.owner.enterprise?
        if block.owner.software?
          software_block = boxTemplateSoftware.blocks.where(:title => block.title).first
          block.mirror_block_id = software_block.id if software_block
        elsif block.owner.institution?
          institution_block = boxTemplateInstitution.blocks.where(:title => block.title).first
          block.mirror_block_id = institution_block.id if institution_block
        end
      end
      print "." if block.save
    end
    puts ""
  end

  def down
    say "This can't be reverted"
  end
end

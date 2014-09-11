class SoftwareCategories < ActiveRecord::Base
  attr_accessible :administration , :agriculture ,  :business_and_services , :communication ,
                  :culture , :national_defense , :economy_and_finances , :education ,
                  :energy , :sports , :habitation , :industry , :environment ,
                  :research_and_development , :social_security , :social_protection ,
                  :international_relations , :sanitation , :health ,
                  :security_public_order , :work , :transportation , :urbanism

  belongs_to :software_info

  validate :verify_blank_fields

  def verify_blank_fields
    ignore_list = ["id", "software_info_id"]

    fields =  self.attribute_names - ignore_list

    one_is_filled = false
    fields.each do |field|
      one_is_filled = true if self[field] == true
    end

    self.errors.add(:base, _("At last one category must be checked")) unless one_is_filled
  end
end
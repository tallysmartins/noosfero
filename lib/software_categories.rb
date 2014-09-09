class SoftwareCategories < ActiveRecord::Base
  attr_accessible :administration , :agriculture ,  :business_and_services , :communication ,
                  :culture , :national_defense , :economy_and_finances , :education ,
                  :energy , :sports , :habitation , :industry , :environment ,
                  :research_and_development , :social_security , :social_protection ,
                  :international_relations , :sanitation , :health ,
                  :security_public_order , :work , :transportation , :urbanism

  belongs_to :software_info
end
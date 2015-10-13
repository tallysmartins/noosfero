class CreateControlledVocabularyTable < ActiveRecord::Migration
  def up
    create_table :controlled_vocabulary do |t|
      t.references :software_info
      t.boolean :administration
      t.boolean :agriculture
      t.boolean :business_and_services
      t.boolean :communication
      t.boolean :culture
      t.boolean :national_defense
      t.boolean :economy_and_finances
      t.boolean :education
      t.boolean :energy
      t.boolean :sports
      t.boolean :habitation
      t.boolean :industry
      t.boolean :environment
      t.boolean :research_and_development
      t.boolean :social_security
      t.boolean :social_protection
      t.boolean :international_relations
      t.boolean :sanitation
      t.boolean :health
      t.boolean :security_public_order
      t.boolean :work
      t.boolean :transportation
      t.boolean :urbanism

    end
  end

  def down
    drop_table :controlled_vocabulary
  end
end

class CreateCommunityRatings < ActiveRecord::Migration
  def change
    create_table :community_ratings do |t|
      t.belongs_to :community
      t.belongs_to :person
      t.integer :value

      t.timestamps
    end
  end
end

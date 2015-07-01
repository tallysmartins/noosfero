class AddCommunityRatingToComments < ActiveRecord::Migration
  def self.up
    change_table :comments do |t|
      t.belongs_to :community_rating
    end
  end

  def self.down
    remove_column :comments, :community_rating_id
  end
end

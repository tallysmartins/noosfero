class CreateCommunityRatingCommentTask < ActiveRecord::Migration
  def up
    change_table :tasks do |t|
      t.belongs_to :community_rating
      t.belongs_to :source, :foreign_key => :source_id
    end
  end

  def down
    remove_column :tasks, :community_ratings_id
    remove_column :tasks, :source_id
  end
end

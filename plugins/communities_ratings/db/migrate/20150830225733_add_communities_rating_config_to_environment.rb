class AddCommunitiesRatingConfigToEnvironment < ActiveRecord::Migration
  	 
  def change
     add_column :environments, :communities_ratings_cooldown, :integer, :default => 24
     add_column :environments, :communities_ratings_default_rating, :integer, :default => 1
     add_column :environments, :communities_ratings_order, :string, :default => "most recent"
     add_column :environments, :communities_ratings_per_page, :integer, :default => 10
     add_column :environments, :communities_ratings_vote_once, :boolean, :default => false
     add_column :environments, :communities_ratings_are_moderated, :boolean, :default => true
  end
end

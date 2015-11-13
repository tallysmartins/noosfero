class AddDisplayCommentToOrganizationRating < ActiveRecord::Migration
  def change
    add_column :organization_ratings, :comment_rejected, :boolean, :default => false
  end
end

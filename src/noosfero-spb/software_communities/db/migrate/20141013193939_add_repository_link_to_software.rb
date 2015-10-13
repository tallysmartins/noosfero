class AddRepositoryLinkToSoftware < ActiveRecord::Migration
  def up
    add_column :software_infos, :repository_link, :string
  end

  def down
    remove_column :software_infos, :repository_link
  end
end

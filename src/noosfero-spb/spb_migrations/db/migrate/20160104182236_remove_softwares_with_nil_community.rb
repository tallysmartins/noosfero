class RemoveSoftwaresWithNilCommunity < ActiveRecord::Migration
  def up
    execute('DELETE FROM software_communities_plugin_software_infos where community_id IS NULL;')
  end

  def down
    say"This migration can't be reverted"
  end
end

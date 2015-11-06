class RemoveSoftwaresWithoutCommunity < ActiveRecord::Migration
  def up
    execute('DELETE FROM software_infos where community_id NOT IN (SELECT id FROM profiles)')
  end

  def down
    say "This migration can't be reverted!"
  end
end

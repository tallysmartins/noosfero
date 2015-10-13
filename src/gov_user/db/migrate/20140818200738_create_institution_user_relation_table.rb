class CreateInstitutionUserRelationTable < ActiveRecord::Migration
  def up
    create_table :institutions_users do |t|
      t.belongs_to :user
      t.belongs_to :institution
    end
  end

  def down
    drop_table :institutions_users
  end
end

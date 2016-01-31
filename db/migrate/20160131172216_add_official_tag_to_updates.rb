class AddOfficialTagToUpdates < ActiveRecord::Migration
  def up
  	add_column :updates, :official, :boolean, :default => false
  end

  def down
  	remove_column :updates, :official
  end
end

class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.string :title
      t.string :url
      t.text :description
      t.references :project
      t.boolean :positive, :default => true
      t.datetime :event_occured
      t.datetime :last_updated
      t.timestamps null: false
    end
  end
end

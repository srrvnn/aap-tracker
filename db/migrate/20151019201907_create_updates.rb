class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.string :title
      t.string :url
      t.text :description
      t.datetime :last_updated  
      t.timestamps null: false
    end
  end
end

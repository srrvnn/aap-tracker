class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.boolean :official, default: false
      t.boolean :volunteer, default: false

      t.timestamps null: false
    end
  end
end

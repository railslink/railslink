class CreateSlackUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :slack_users do |t|
      t.string :uid, index: true
      t.string :email, index: true
      t.string :username, index: true
      t.string :first_name
      t.string :last_name
      t.string :tz
      t.integer :tz_offset
      t.string :locale
      t.boolean :is_deleted, index: true
      t.boolean :is_admin, index: true
      t.boolean :is_bot
      t.json :data, default: {}

      t.timestamps
    end
  end
end

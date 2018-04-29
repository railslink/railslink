class CreateSlackChannels < ActiveRecord::Migration[5.1]
  def change
    create_table :slack_channels do |t|
      t.string :uid, index: true
      t.string :name
      t.boolean :is_archived
      t.boolean :is_general, default: false, index: true
      t.boolean :is_private
      t.text :purpose
      t.integer :members_count, default: 0
      t.json :data, default: {}

      t.timestamps
    end
  end
end

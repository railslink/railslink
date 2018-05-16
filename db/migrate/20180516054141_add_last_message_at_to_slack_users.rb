class AddLastMessageAtToSlackUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :slack_users, :last_message_at, :datetime
  end
end

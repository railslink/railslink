class AddPronounsToSlackUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :slack_users, :pronouns, :string
  end
end

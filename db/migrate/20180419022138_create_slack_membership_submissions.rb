class CreateSlackMembershipSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :slack_membership_submissions do |t|
      t.references :slack_user
      t.integer :status, default: 0, index: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :location
      t.text :introduction
      t.text :how_hear
      t.string :linkedin_url
      t.string :github_url
      t.string :website_url

      t.timestamps
    end

    add_index :slack_membership_submissions, :email, unique: true
  end
end

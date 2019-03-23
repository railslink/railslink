class AddIpAddressToSlackMembershipSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :slack_membership_submissions, :ip_address, :inet
  end
end

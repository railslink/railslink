class AddPerformanceIndexes < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  # Admin "pending" filters on status and orders by created_at; only status was
  # indexed, so Postgres had to sort the matching rows. The dashboard's
  # registered_* scopes all filter on users.created_at, which had no index at all.
  # Built concurrently so the ~91k / ~38k row tables stay writable.
  def change
    add_index :slack_membership_submissions, [:status, :created_at],
      algorithm: :concurrently, if_not_exists: true

    add_index :slack_users, :created_at,
      algorithm: :concurrently, if_not_exists: true
  end
end

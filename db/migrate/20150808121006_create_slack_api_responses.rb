class CreateSlackApiResponses < ActiveRecord::Migration
  def change
    create_table :slack_api_responses do |t|
      t.text       :method_name, null: false
      t.boolean    :ok, null: false
      t.jsonb      :response, null: false, default: {}
      t.timestamps null: false, index: true
    end
  end
end

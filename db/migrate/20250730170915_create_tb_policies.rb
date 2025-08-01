# db/migrate/20250730170915_create_tb_policies.rb
class CreateTbPolicies < ActiveRecord::Migration[8.0]
  def change
    create_table :tb_policies, id: :uuid do |t|
      t.string :policy_number, limit: 12, null: false, unique: true
      t.references :tb_customer, null: false, foreign_key: true, type: :string
      t.datetime :start_date
      t.datetime :end_date
      t.string :status
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end
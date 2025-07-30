class CreateTbCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :tb_customers, id: false do |t|
      t.string :id, primary_key: true
      t.string :username, null: false
      t.string :password, null: false
      t.string :role, null: false
      t.datetime :createdAt, null: false
      t.datetime :updatedAt, null: false
    end
    add_index :tb_customers, :username, unique: true
  end
end
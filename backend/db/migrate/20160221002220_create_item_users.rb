class CreateItemUsers < ActiveRecord::Migration
  def change
    create_table :item_users do |t|
      t.integer  :user_id
      t.integer  :item_id
      t.integer  :status,     null: false

      t.timestamps null: false
    end
  end
end

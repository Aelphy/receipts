class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer  :receipt_id
      t.string   :name,           null: false
      t.integer  :price,          null: false
      t.integer  :currency_id,    null: false
      t.float    :amount,         null: false
      t.integer  :amount_type_id, null: false

      t.timestamps null: false
    end
  end
end

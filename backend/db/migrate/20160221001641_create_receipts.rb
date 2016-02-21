class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.integer  :creditor_id
      t.integer  :currency_id
      t.string   :shop_name
      t.integer  :status, null: false
      t.float    :discount, default: 0.0, null: false
      t.integer  :total_price

      t.timestamps null: false
    end
  end
end

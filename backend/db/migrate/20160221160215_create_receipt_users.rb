class CreateReceiptUsers < ActiveRecord::Migration
  def change
    create_table :receipt_users do |t|
      t.references :user
      t.references :receipt

      t.timestamps null: false
    end
  end
end

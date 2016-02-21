class CreateCurrencyUsers < ActiveRecord::Migration
  def change
    create_table :currency_users do |t|
      t.references :user
      t.references :currency

      t.timestamps null: false
    end
  end
end

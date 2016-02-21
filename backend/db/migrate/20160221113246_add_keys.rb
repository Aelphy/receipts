class AddKeys < ActiveRecord::Migration
  def change
    add_foreign_key "currency_users", "currencies", name: "currency_users_currency_id_fk"
    add_foreign_key "currency_users", "users", name: "currency_users_user_id_fk"
    add_foreign_key "images", "receipts", column: "reference_id", name: "images_reference_id_fk"
    add_foreign_key "item_users", "items", name: "item_users_item_id_fk"
    add_foreign_key "item_users", "users", name: "item_users_user_id_fk"
    add_foreign_key "items", "amount_types", name: "items_amount_type_id_fk"
    add_foreign_key "items", "currencies", name: "items_currency_id_fk"
    add_foreign_key "items", "receipts", name: "items_receipt_id_fk"
    add_foreign_key "notifications", "users", column: "author_id", name: "notifications_author_id_fk"
    add_foreign_key "notifications", "receipts", column: "reference_id", name: "notifications_reference_id_fk"
    add_foreign_key "notifications", "users", name: "notifications_user_id_fk"
    add_foreign_key "receipts", "users", column: "creditor_id", name: "receipts_creditor_id_fk"
    add_foreign_key "receipts", "currencies", name: "receipts_currency_id_fk"
    add_foreign_key "sessions", "users", name: "sessions_user_id_fk"
  end
end

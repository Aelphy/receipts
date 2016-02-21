class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user
      t.text :message
      t.integer :status, null: false
      t.string :type
      t.integer :reference_id
      t.integer  :author_id

      t.timestamps null: false
    end
  end
end

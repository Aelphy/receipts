class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.attachment :photo
      t.integer :reference_id
      t.string :type

      t.timestamps null: false
    end
  end
end

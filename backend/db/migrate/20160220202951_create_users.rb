class CreateUsers < ActiveRecord::Migration
  def change
      create_table(:users) do |t|
        # default login field
        t.string :phone, null: false
        t.string :email
        t.string :name
        t.string :encrypted_password, null: false

        t.integer   :login_count, default: 0, null: false
        t.integer   :failed_login_count, default: 0, null: false
        t.datetime  :current_sign_in_at
        t.datetime  :last_sign_in_at
        t.string    :current_sign_in_ip
        t.string    :last_sign_in_ip

        t.timestamps
      end

      add_index :users, :phone
    end
end

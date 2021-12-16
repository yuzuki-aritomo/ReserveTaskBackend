class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table(:users, unsigned: true) do |t|
      ## Required
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""

      ## Database authenticatable
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean  :allow_password_change, :default => false

      ## User Info
      t.string :name, :null => false
      t.string :email, :null => false

      ## Tokens
      t.text :tokens

      #custom
      t.integer :role, limit: 1, :null => false

      t.timestamps
    end

    add_index :users, :email,              unique: true
    add_index :users, [:uid, :provider],     unique: true
    add_index :users, :reset_password_token, unique: true
  end
end

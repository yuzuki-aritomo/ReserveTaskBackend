class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations, unsigned: true do |t|
      t.references :user,         null: false,  foreign_key: true, unsigned: true
      t.references :reception, null: false,  foreign_key: true, unsigned: true
      t.boolean :cancel_flag,   null: false,  :default => false
      t.timestamps
    end
  end
end

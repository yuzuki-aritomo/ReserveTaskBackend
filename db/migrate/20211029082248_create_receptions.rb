class CreateReceptions < ActiveRecord::Migration[6.0]
  def change
    create_table :receptions, unsigned: true do |t|
      t.references :user, null: false, foreign_key: true, unsigned: true
      t.datetime :date, null: false, index: true
      t.timestamps
    end
    add_index :receptions, [:user_id, :date], unique: true
  end
end

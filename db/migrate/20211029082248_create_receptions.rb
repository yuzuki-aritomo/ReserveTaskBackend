class CreateReceptions < ActiveRecord::Migration[6.0]
  def change
    create_table :receptions, unsigned: true do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :date, null: false, index: true
      t.timestamps
    end
  end
end

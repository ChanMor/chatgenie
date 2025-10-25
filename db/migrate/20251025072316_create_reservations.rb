class CreateReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :table, null: false, foreign_key: true
      t.datetime :reservation_time
      t.integer :party_size

      t.timestamps
    end
  end
end

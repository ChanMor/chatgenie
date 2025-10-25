class AddTimeSlotToReservations < ActiveRecord::Migration[8.1]
  def change
    add_reference :reservations, :time_slot, foreign_key: true
    add_column :reservations, :table_capacity, :integer
    
    # Add index for faster queries
    add_index :reservations, [:time_slot_id, :created_at]
  end
end

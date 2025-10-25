class CreateTimeSlots < ActiveRecord::Migration[8.1]
  def change
    create_table :time_slots do |t|
      t.datetime :start_time, null: false
      t.integer :max_tables, null: false, default: 1
      t.integer :table_capacity, null: false

      t.timestamps
    end
    
    add_index :time_slots, :start_time
  end
end

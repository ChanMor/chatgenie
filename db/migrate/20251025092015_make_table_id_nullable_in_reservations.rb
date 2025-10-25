class MakeTableIdNullableInReservations < ActiveRecord::Migration[8.1]
  def change
    change_column_null :reservations, :table_id, true
  end
end

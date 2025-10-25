class CreateTables < ActiveRecord::Migration[8.1]
  def change
    create_table :tables do |t|
      t.string :name
      t.integer :capacity

      t.timestamps
    end
  end
end

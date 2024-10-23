class CreateParkings < ActiveRecord::Migration[7.2]
  def change
    create_table :parkings do |t|
      t.string :plate, null: false, limit: 8
      t.datetime :entry_time
      t.datetime :exit_time
      t.boolean :paid, default: false
      t.boolean :left, default: false

      t.timestamps
    end
  end
end

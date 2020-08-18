class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :event_name
      t.date :date
      t.string :location
      t.string :duration 
      t.integer :client_id
      t.integer :event_planner_id
    end
  end
end

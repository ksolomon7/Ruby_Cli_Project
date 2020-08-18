class CreateEventPlanners < ActiveRecord::Migration[5.2]
  def change
    create_table :event_planners do |t|
      t.string :name
      t.string :phone_number
      t.string :email
      t.integer :years_of_experience
      t.string :title
    end
  end
end

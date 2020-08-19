class EventPlanner < ActiveRecord::Base
  has_many :events
  has_many :clients, through: :events

  attr_accessor :yourevent

    def self.create_event_for_client(role)
        prompt=TTY::Prompt.new
        result = prompt.collect do
            key(:event_name).ask("What would you like to call your event?")
            key(:date).ask("When is your event? (Enter: DD/MM/YYYY):", convert: :date)
            key(:location).ask("In what location, are you having this event?")
            key(:duration).ask("How long is your event going to be?(Enter in the format: 2 hrs)")
            key(:client_id).ask("What is your name?", default: "#{role.id}")
            key(:event_planner_id).select 
        end

#added this to self.create_event_for_client because I wanted to add the specific client id by doing result[:client.id]= role.id
# can add name for event planner and pick from eventplanner.all

    end
end

class EventPlanner < ActiveRecord::Base
  has_many :events
  has_many :clients, through: :events

  attr_accessor :yourevent

    def self.create_event_for_client(role)
        prompt=TTY::Prompt.new
        

      result = prompt.collect do
        key(:event_name).ask("What would you like to call your event?").capitalize
        key(:date).ask("When is your event? (Enter: DD/MM/YYYY):", convert: :date)
        key(:location).ask("In what location, are you having this event?").capitalize
        key(:duration).ask("How long is your event going to be?(Enter in the format: 2 hrs)")
        key(:event_planner_id).ask("Validate your account number", value: "#{role.id}")
        key(:client_id).ask("Who is your client?", value: "None")
      end
         Event.create(result)


       puts "\n"
       puts "Event has been created! You will be redirected to the main_menu to view the events.".colorize(:yellow)
       puts "\n"
       sleep 3
       YourEvent.home_page(role)
    end

end

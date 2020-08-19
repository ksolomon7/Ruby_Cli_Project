class Client < ActiveRecord::Base
    has_many :events
    has_many :event_planners, through: :events

    attr_accessor :yourevent

    def self.create_event_for_client(role)
        prompt=TTY::Prompt.new

        result = prompt.collect do
            key(:event_name).ask("What would you like to call your event?").capitalize
            key(:date).ask("When is your event? (Enter: DD/MM/YYYY):", convert: :date)
            key(:location).ask("In what location, are you having this event?").capitalize
            key(:duration).ask("How long is your event going to be?(Enter in the format: 2 hrs)")
            key(:client_id).ask("Validate your account number", value: "#{role.id}")
            key(:event_planner_id).ask("Who is your event planner?", value: "None")
        end
           new_event=Event.create(result)


           puts "\n"
           puts "Event has been created! You will be redirected to the main_menu to view the events.".colorize(:yellow)
           puts "\n"
           sleep 3
           YourEvent.home_page(role)
    end


# Notes
# event_planner_choices= EventPlanner.all.collect do |event_planner|
#     event_planner.name
# end

        #  To update the client_id to an integer
        #    Event.last.select do |info|
        #      if info.client_id
        #         info.client_id.to_in
        #      end
        #    end
#added this to self.create_event_for_client because I wanted to add the specific client id by doing result[:client.id]= role.id
# can add name for event planner and pick from eventplanner.all

end

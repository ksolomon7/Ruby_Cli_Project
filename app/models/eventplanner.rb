class EventPlanner < ActiveRecord::Base
  has_many :events
  has_many :clients, through: :events

  attr_accessor :yourevent

  def self.view_event_for_event_planner(role)
    puts "You have #{role.events.count} events!"
    parties= Event.where(event_planner_id: role.id)
    options=parties.map do |party|
      party.event_name
    end

    prompt=TTY::Prompt.new
    move= prompt.select("\n", options)

    options.select do |event|
      if event == move
        found_event=Event.find_by(event_name: move)
        
        puts "***********************************************************************".colorize(:green) 
        puts "\n"
        puts "EVENT NAME: #{found_event.event_name}".colorize(:yellow)
        puts "DATE: #{found_event.date}".colorize(:yellow)
        puts "LOCATION: #{found_event.location}".colorize(:yellow)
        puts "DURATION: #{found_event.duration}".colorize(:yellow)
        puts "\n"
          if found_event.event_planner != nil
        puts "EVENTPLANNER: #{found_event.event_planner.name}".colorize(:red)
          elsif found_event.event_planner == nil
        puts "EVENTPLANNER: None".colorize(:red)
          end
          if found_event.client != nil
        puts "CLIENT: #{found_event.client.name}".colorize(:red)
          elsif found_event.client == nil
        puts "CLIENT ACCOUNT NUMBER: #{found_event.client.id}".colorize(:red)
          end
        puts "\n"
        puts "***********************************************************************".colorize(:green) 
      end
    end
    puts "\n"
    puts "....going back to the main page!!".colorize(:yellow)
    sleep 4
    YourEvent.home_page(role)
end

    def self.create_event_for_client(role)
        prompt=TTY::Prompt.new
        

      result = prompt.collect do
        key(:event_name).ask("What would you like to call your event?") 
        key(:date).ask("When is your event? (Enter: DD/MM/YYYY):", convert: :date)
        key(:location).ask("In what location, are you having this event?")
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

    def self.delete_event_for_event_planner(role)
      parties= Event.where(event_planner_id: role.id)
      options=parties.map do |party|
        party.event_name
      end

      puts "Which event would you like to remove?"
      prompt=TTY::Prompt.new
      event_options= prompt.select("\n", options)
      deleting_event=Event.find_by(event_name: event_options)
      deleting_event.destroy
      puts "\n"
      puts "Your event has been removed!".colorize(:red)
      YourEvent.home_page(role)
    end

end

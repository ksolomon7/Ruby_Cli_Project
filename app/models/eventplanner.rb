class EventPlanner < ActiveRecord::Base
  has_many :events
  has_many :clients, through: :events

  @@prompt=TTY::Prompt.new
  attr_accessor :yourevent

  def self.view_event_for_event_planner(role)
    puts "You have #{role.events.count} events!"
    parties= Event.where(event_planner_id: role.id)
    options=parties.map {|party| party.event_name}

    move=@@prompt.select("\n", options)

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

    def self.create_event_for_event_planner(role)
        
      event_name = @@prompt.ask("What would you like to call your event?") 
      date = @@prompt.ask("When is your event? (Enter: DD/MM/YYYY):", convert: :date)
      location = @@prompt.ask("In what location, are you having this event?")
      duration = @@prompt.ask("How long is your event going to be?(Enter in the format: 2 hrs)")
      event_planner_id = @@prompt.ask("Validate your account number", value: "#{role.id}")
      client_id = Client.all.map { |client| client.name }
      select_client_name = @@prompt.select("Who is your client?", client_id)
      client_name = Client.find_by(name: select_client_name).id
      Event.create(event_name: event_name, date: date, location: location, duration: duration, client_id: client_name, event_planner_id: event_planner_id)

       puts "\n"
       puts "Event has been created! You will be redirected to the main_menu to view the events.".colorize(:yellow)
       puts "\n"
       sleep 3
       system 'clear'
       YourEvent.home_page(role)
    end

    def self.delete_event_for_event_planner(role)
      parties= Event.where(event_planner_id: role.id)
      options=parties.map {|party| party.event_name}

      puts "Which event would you like to remove?"
    
      event_options= @@prompt.select("\n", options)
      deleting_event=Event.find_by(event_name: event_options)
      deleting_event.destroy
      puts "\n"
      puts "Your event has been removed!".colorize(:red)
      YourEvent.home_page(role)
    end

end

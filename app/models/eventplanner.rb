class EventPlanner < ActiveRecord::Base
  has_many :events
  has_many :clients, through: :events

  @@prompt=TTY::Prompt.new
  attr_accessor :yourevent


##############################################VIEW EVENT METHOD########################################################
  def self.view_event_for_event_planner(role)
    puts "You have #{role.events.count} events!"
    
    if role.events.count == 0
      sleep 2
      system 'clear'
      YourEvent.home_page(role)
    else 
    parties= Event.where(event_planner_id: role.id)
    options=parties.map {|party| party.event_name}

    move=@@prompt.select("\n", options)

    options.select do |event|
      if event == move
        found_event=Event.find_by(event_name: move)
        
        puts "***********************************************************************".colorize(:cyan) 
        puts "\n"
        puts "EVENT NAME: #{found_event.event_name}".colorize(:magenta)
        puts "DATE: #{found_event.date}".colorize(:magenta)
        puts "LOCATION: #{found_event.location}".colorize(:magenta)
        puts "DURATION: #{found_event.duration}".colorize(:magenta)
        puts "\n"
          if found_event.event_planner != nil
        puts "EVENTPLANNER: #{found_event.event_planner.name}".colorize(:blue)
          elsif found_event.event_planner == nil
        puts "EVENTPLANNER: None".colorize(:blue)
          end
          if found_event.client != nil
        puts "CLIENT: #{found_event.client.name}".colorize(:blue)
          elsif found_event.client == nil
        puts "CLIENT ACCOUNT NUMBER: #{found_event.client.id}".colorize(:blue)
          end
        puts "\n"
        puts "***********************************************************************".colorize(:cyan) 
      end
    end
    puts "\n"
    puts "....going back to the main page!!".colorize(:white)
    sleep 6
    system 'clear'
    YourEvent.home_page(role)
    end
end

###############################################CREATE EVENT METHOD##############################################################

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

#######################################################DELETE METHOD#########################################################
    def self.delete_event_for_event_planner(role)
      parties= Event.where(event_planner_id: role.id)
      options=parties.map {|party| party.event_name}

      puts "Which event would you like to remove?"
    
      event_options= @@prompt.select("\n", options)
      deleting_event=Event.find_by(event_name: event_options)
      deleting_event.destroy
      puts "\n"
      puts "Your event has been removed!".colorize(:red)
      sleep 2
      system 'clear'
      YourEvent.home_page(role)
    end

#################################################UPDATE EVENT METHOD#########################################################

    def self.update_event_for_event_planner(role)
      parties= Event.where(event_planner_id: role.id)
      options=parties.map {|party|party.event_name}
      event_options=@@prompt.select("\n", options)
      choices=["Change Event Name", "Change Event Date", "Change Duration", "Change Location", "Go back"]

      navigator= @@prompt.select("Please select an option:", choices)

      if navigator == "Change Event Name"
        found_event=Event.find_by(event_name: event_options)
        new_name=@@prompt.ask("What is the new event name?")
        new_name_change=found_event.update(event_name: new_name)
        sleep 3
        system 'clear'
        YourEvent.home_page(role)
      elsif navigator == "Change Event Date"
        found_event=Event.find_by(event_name: event_options)
        date=@@prompt.ask("When is the event date? DD/MM/YYYY")
        date_change=found_event.update(date: date)
        sleep 3
        system 'clear'
        YourEvent.home_page(role)
      elsif navigator == "Change Duration"
        found_event=Event.find_by(event_name: event_options)
        duration=@@prompt.ask("How long is the event?")
        duration_change=found_event.update(duration: duration)
        sleep 3
        system 'clear'
        YourEvent.home_page(role)
      elsif navigator == "Change Location"
        found_event=Event.find_by(event_name: event_options)
        location=@@prompt.ask("Where is the new location?")
        location_change=found_event.update(location: location)
        sleep 3
        system 'clear'
        YourEvent.home_page(role)
      elsif navigator == "Go back"
          puts "Going back to the main menu!".colorize(:yellow)
          sleep 3
          system 'clear'
          YourEvent.home_page(role)
      end
end

end

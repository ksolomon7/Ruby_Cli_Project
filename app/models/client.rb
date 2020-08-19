require 'pry'
class Client < ActiveRecord::Base
    has_many :events
    has_many :event_planners, through: :events

    attr_accessor :yourevent

    def self.view_event_for_client(role)
        puts "You have #{role.events.count} events!"

        if role.events.count == 0
            YourEvent.home_page(role)
        else 
            parties= Event.where(client_id: role.id)
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
    end

        puts "\n"
        puts "....going back to the main page!!".colorize(:yellow)
        sleep 4
        system 'clear'
        YourEvent.main_menu(role)
    end


    def self.create_event_for_client(role)
        prompt=TTY::Prompt.new

        event_planner_options= EventPlanner.all.map do |event_planner|
                                    event_planner.name
                               end
        
        
        event_name=prompt.ask("What would you like to call your event?")
        date=prompt.ask("When is your event? (Enter: DD/MM/YYYY):", convert: :date)
        location=prompt.ask("In what location, are you having this event?")
        duration=prompt.ask("How long is your event going to be?(Enter in the format: 2 hrs)")
        client_id=prompt.ask("Validate your account number", value: "#{role.id}")
        event_planner= prompt.select("Choose an event planner?", event_planner_options)
    
          
        planner_id=EventPlanner.find_by(name: event_planner).id
        Event.create(event_name: event_name, date: date, location: location, duration: duration, client_id: client_id, event_planner_id: planner_id)
     

           puts "\n"
           puts "Event has been created! You will be redirected to the main_menu to view the events.".colorize(:yellow)
           puts "\n"

           sleep 3
           YourEvent.home_page(role)
    end

    def self.delete_event_for_client(role)
        parties= Event.where(client_id: role.id)
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

class Event < ActiveRecord::Base
  belongs_to :client
  belongs_to :event_planner
  has_many :tasks

  attr_accessor :yourevent

  def self.view_events(role)
    puts "You have #{role.events.count} events!"
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
    puts "\n"
    puts "....going back to the main page!!".colorize(:yellow)
    sleep 4
    YourEvent.home_page(role)
  end 

  def self.create_events(role)
    Event.is_a_client_or_an_event_planner?(role)
   
      # Event.create(result)
      # binding.pry
      # Event.view_events(role)
    end
  ################################################HELPER METHOD#####################################################################

  def self.is_a_client_or_an_event_planner?(role)
    if Client.find_by(email: role.email)
      Client.create_event_for_client(role)
    elsif EventPlanner.find_by(email: role.email)
      EventPlanner.create_event_for_event_planner(role)
    end
  end
end

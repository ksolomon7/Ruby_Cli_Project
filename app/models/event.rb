class Event < ActiveRecord::Base
  belongs_to :client
  belongs_to :event_planner
  has_many :tasks

  attr_accessor :yourevent

  def self.view_events(role)
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
        puts "EVENTPLANNER: #{found_event.event_planner.name}".colorize(:red)
        puts "CLIENT: #{found_event.client.name}".colorize(:red)
        puts "\n"
        puts "***********************************************************************".colorize(:green) 
      end
    end
    
    puts "....going back to the main page!!".colorize(:yellow)
    YourEvent.home_page(role)
  end 

  def self.create_events(role)
    binding.pry
    is_a_client_or_an_event_planner(role)

    # prompt=TTY::Prompt.new
    # result = prompt.collect do
    #   key(:event_name).ask("What would you like to call your event?")
    #   key(:date).ask("When is your event? (Enter: DD/MM/YYYY):", convert: :date)
    #   key(:location).ask("In what location, are you having this event?")
    #   key(:duration).ask("How long is your event going to be?(Enter in the format: 2 hrs)")
    #   # key(:client_id).ask("What is your name?", default: "#{role.id}")
    #   # key(:event_planner_id).select 
    #   end

    
   
      Event.create(result)
      binding.pry
      Event.view_events(role)
    end
  ################################################HELPER METHOD#####################################################################

  def is_a_client_or_an_event_planner?(role)
    if Client.find_by(email: role.email)
      Client.create_event_for_client(role)
    elsif EventPlanner.find_by(email: role.email)
      EventPlanner.create_event_for_event_planner(role)
    end
  end
  # event_name: Faker::Company.name,
  #           date: Faker::Date.in_date_period,
  #           location: Faker::Address.state,
  #           duration: duration_options, 
  #           client_id: client.id,
  #           event_planner_id: EventPlanner.all.sample.id
  #       )
end

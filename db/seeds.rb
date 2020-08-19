Client.destroy_all
EventPlanner.destroy_all
Event.destroy_all
Client.reset_pk_sequence
EventPlanner.reset_pk_sequence
Event.reset_pk_sequence

#####SEEDS#######

def create_client

    client= Client.create(
        name: Faker::Name.name,
        phone_number: Faker::PhoneNumber.cell_phone,
        email: Faker::Internet.email
    )
end

def create_event_planner 

    title_name = ["Senior EventPlanner", "Junior EventPlanner"].sample
    event_planner= EventPlanner.create(
        name: Faker::Name.name_with_middle,
        phone_number: Faker::PhoneNumber.cell_phone,
        years_of_experience: rand(5..20),
        email: Faker::Internet.email,
        title: title_name
    )
end


def create_joiners(client)
    duration_options = ["2 hrs", "3 hrs", "4 hrs", "5 hrs", "6 hrs"].sample
        Event.create(
            event_name: Faker::Company.name,
            date: Faker::Date.in_date_period,
            location: Faker::Address.state,
            duration: duration_options, 
            client_id: client.id,
            event_planner_id: EventPlanner.all.sample.id
        )
end 

  10.times do 
    create_event_planner
    create_joiners(create_client)
  end

  daisy= Client.create(name: "Daisy", phone_number: "212-914-2567", email: "klmnt@yahoo.com")
  bella= EventPlanner.create(name: "Bella", phone_number: "545-279-0765", years_of_experience: 10, email: "belb12@yahoo.com", title: "Senior Event Planner")
  party= Event.create(event_name: "Party Central", date: Faker::Date.in_date_period, location: "Los Angeles", duration: "2 hrs", client_id:Client.find_by(name: "Daisy").id, event_planner_id: EventPlanner.find_by(name: "Bella").id )
  alcohol=Event.create(event_name: "Booze Fest", date: Faker::Date.in_date_period, location: "In my room", duration: "6 hrs", client_id:Client.find_by(name: "Daisy").id, event_planner_id: EventPlanner.find_by(name: "Bella").id )
############################Task -stretch feature######################################
#   def create_task(event)
#         status_option= ["Complete", "Incomplete", "Pending"].sample
#         note_options=["Finalize location",
#               "Estimate costs",
#               "Event budget",
#               "Build an event website",
#               "Identify sponsors",
#               "Create guest list",
#               "Rental items"].sample

#         Task.create(
#            note: note_options,
#            status: status_option,
#            event_id: event.id 
#         )
#   end
 
# if task model and task tables were added
# 10.times do 
#     create_event_planner
#     create_joiners(create_client)
#     create_task(event)
#   end

puts "🔥 🔥 🔥 🔥 "
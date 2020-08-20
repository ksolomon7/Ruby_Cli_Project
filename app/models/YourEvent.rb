class YourEvent

   attr_accessor :prompt, :client, :event, :eventplanner, :art 

   
   def initialize
    @prompt=TTY::Prompt.new
   end

  
   def welcome
    puts ".....................................................................................".colorize(:white)
    puts "\n"
    puts "      Welcome to YourEvents. The app that knows what fun you are up to!".colorize(:yellow)
    puts "\n"
    puts ".....................................................................................".colorize(:white)

   end

   def login_or_register
    option=prompt.select("Would you like to login or create an account?", %w(Login Register))
      if option == "Login" 
        login(client_or_event_planner)
      elsif option == "Register"
        puts "REGISTERING ACCOUNT INFO".colorize(:yellow)
        register(verify_email)
      end
   end 
  
   def client_or_event_planner
    prompt.select("Are you a client or eventplanner?", %w(Client EventPlanner))
   end

   def login(role_str)
       role=role_str.constantize
       puts "Please provide your email to login:".colorize(:yellow)
       email=STDIN.gets.chomp.downcase
         if role.find_by(email: email) != nil
            puts "Welcome back, #{role.find_by(email: email).name}!".colorize(:yellow)
            sleep 3
            system 'clear'
            YourEvent.home_page(role.find_by(email: email))
          # YourEvent.main_menu(role.find_by(email: email))
         elsif role.find_by(email: email) == nil
            puts "Sorry! This email does not exist.".colorize(:red)
            sleep 3
            system 'clear'
            login_or_register
        end
   end

   def register(email)
     role= prompt.select("Would you like to create a Client Account or a EventPlanner Account?", %w(Client EventPlanner))
     role_str=role.constantize
        if role_str == Client
            result = prompt.collect do
            key(:name).ask("What is your fullname?")
            key(:phone_number).ask("What is your cellphone number?")
            key(:email).ask("Verify your email")
            end
            puts "Welcome to YourEvent page!".colorize(:yellow)
            sleep 2
            system 'clear'
            YourEvent.home_page(role_str.create(result))
        elsif role_str == EventPlanner
          result = prompt.collect do
            key(:name).ask("What is your fullname?")
            key(:phone_number).ask("What is your cellphone number?")
            key(:years_of_experience).ask("How many years of experience do you have?", convert: :int)
            key(:email).ask("Verify your email")
            key(:title).ask("Are you a Senior EventPlanner or Junior EventPlanner?")
            end
            puts "Welcome to YourEvent page!".colorize(:yellow)
            sleep 2
            system 'clear'
            YourEvent.home_page(role_str.create(result))
          end
   end

 
     def self.home_page(role)
      puts '*******************************************************************************************************************************'.colorize(:blue)
      a= Artii::Base.new 
      puts a.asciify ('                                  YourEvent                                                                ')
      # puts '                                  YOUR EVENTS                                                       '.colorize(:yellow)
      puts '*******************************************************************************************************************************'.colorize(:blue)
      puts "Please choose from the following options:".colorize(:yellow)
      choices = ["View Events", "Create An Event", "Update Your Events", "Delete Your Events", "Logout"]

      prompt=TTY::Prompt.new
      navigator =prompt.select("\n", choices)
      if navigator == "View Events"
        Event.view_events(role)
      elsif navigator == "Create An Event"
        Event.create_events(role)
      elsif navigator == "Update Your Events"
        Event.update_events(role)
      elsif navigator == "Delete Your Events"
        Event.delete_events(role)
      elsif navigator == "Logout"
       YourEvent.Logout 
      end
    end

    def run
      Art.picture_two
      welcome
      login_or_register
    end

    def self.Logout
      system 'clear'
      puts "\n"
      Art.picture_one
      puts " ❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️Come back soon❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️".colorize(:blue)
      puts "\n"
      sleep 2
      system 'clear'
    end
end

   ##########################################################HELPER METHODS################################################

   def verify_email
    # email=STDIN.gets.chomp.downcase
    prompt.ask("What is your email?") do |q|
      q.validate(/\A\w+@\w+\.\w+\Z/)
      q.messages[:valid?]="Invalid email address"
    end
   end
  

class YourEvent

   attr_accessor :prompt
   
   def initialize
    @prompt=TTY::Prompt.new
   end

   def welcome
    puts "Welcome to YourEvents. The app that knows what fun you are up to!".colorize(:yellow)
   end

   def client_or_event_planner
    prompt.select("Are you a client or eventplanner?", %w(Client EventPlanner))
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
  
   def login(role_str)
       role=role_str.constantize
       puts "Please provide your email to login:".colorize(:yellow)
       email=STDIN.gets.chomp.downcase
         if role.find_by(email: email) != nil
            puts "Welcome back #{role.find_by(email: email).name}!".colorize(:yellow)
            sleep 3
          main_menu(role.find_by(email: email))
         elsif role.find_by(email: email) == nil
            puts "Sorry! This email does not exist.".colorize(:red)
            sleep 3
            login(client_or_event_planner)
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
            role_str.create(result)
        elsif role_str == EventPlanner
          result = prompt.collect do
            key(:name).ask("What is your fullname?")
            key(:phone_number).ask("What is your cellphone number?")
            key(:email).ask(Verify your email)
            end
            role_str.create(result)
          end
   end

   def main_menu(role)
      puts '*******************************************************************************************************************************'.colorize(:blue)
      puts '                                                     MAIN MENU                                                                 '.colorize(:yellow)
      puts '*******************************************************************************************************************************'.colorize(:blue)
      puts "Welcome to the main menu. Please choose from the following options:".colorize(:yellow)
      user_home_page(role)
   end

   def run
    welcome
    login_or_register
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
  #  def user_home_page(role)
  #     choices = ["View Events", "Create An Event", "Update Your Events", "Delete Your Events", "Logout"]
  #     navigator = @@prompt.select("\n", choices)
  #     if nav == "View Events"
  #       user.select_a_tip
  #     elsif nav == "Saved Tips"
  #       user.user_saved_tips
  #     else
  #       CommandLineInterface.landing_page
  #     end
  #   end

   

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

   def login_or_signup(role_str)
     role=role_str.constantize
     puts "Please provide your email to login:".colorize(:yellow)
     email=STDIN.gets.chomp.downcase
      if role.find_by(email: email) != nil
          puts "Welcome back #{role.find_by(email: email).name}!".colorize(:yellow)
          sleep 3
          main_menu(role.find_by(email: email))
      elsif role.find_by(email: email) == nil
          puts "Sorry! This email does not exist.".colorize(:red)
          puts "Please re-enter your email "
          sleep 3
          login_or_signup(client_or_event_planner)
      end
   end

   def main_menu(role)
      puts '*******************************************************************************************************************************'.colorize(:blue)
      puts '                                                     MAIN MENU                                                                 '.colorize(:yellow)
      puts '*******************************************************************************************************************************'.colorize(:blue)
      puts "Welcome to the main menu. Please choose from the following options:".colorize(:yellow)
   end

    def run
       welcome
       login_or_signup(client_or_event_planner)
    end

  #############################NOTES################################
  #  def self.user_home_page(user)
  #   choices = ["More Tips", "Saved Tips", "Logout"]
  #   nav = @@prompt.select("\n", choices)
  #   if nav == "More Tips"
  #     user.select_a_tip
  #   elsif nav == "Saved Tips"
  #     user.user_saved_tips
  #   else
  #     CommandLineInterface.landing_page
  #   end
  # end

##################################################HELPER METHODS!!!########################################################

end

class Event < ActiveRecord::Base
  belongs_to :client
  belongs_to :event_planner
  has_many :tasks

  attr_accessor :yourevent

  def self.view_events(role)
    Event.is_for_a_client_or_planner_viewing_event?(role)
  end 

  def self.create_events(role)
    Event.is_for_a_client_or_an_event_planner?(role)
  end

  def self.delete_events(role)  
    Event.is_for_a_client_or_an_event_planner_deleting_event?(role)
  end
  ################################################HELPER METHOD#####################################################################

  def self.is_for_a_client_or_an_event_planner?(role)
    if Client.find_by(email: role.email)
      Client.create_event_for_client(role)
    elsif EventPlanner.find_by(email: role.email)
      EventPlanner.create_event_for_event_planner(role)
    end
  end

  def self.is_for_a_client_or_planner_viewing_event?(role)
    if Client.find_by(email: role.email)
      Client.view_event_for_client(role)
    elsif EventPlanner.find_by(email: role.email)
      EventPlanner.view_event_for_event_planner(role)
    end
  end

  def self.is_for_a_client_or_an_event_planner_deleting_event?(role)
    if Client.find_by(email: role.email)
      Client.delete_event_for_client(role)
    elsif EventPlanner.find_by(email: role.email)
      EventPlanner.delete_event_for_event_planner(role)
    end
  end
end

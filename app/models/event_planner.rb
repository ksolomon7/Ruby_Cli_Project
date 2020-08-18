class EventPlanner < ActiveRecord::Base
  has_many :events
  has_many :clients, through: :events
end

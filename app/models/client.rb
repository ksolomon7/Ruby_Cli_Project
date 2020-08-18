class Client < ActiveRecord::Base
    has_many :events
    has_many :event_planners, through: :events
end

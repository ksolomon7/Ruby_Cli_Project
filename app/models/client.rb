class Client < ActiveRecord::Base
    has_many :events
    has_many :event_planners, through: :events

    # def self.create_new(info)
    #     Client.create(name)
    # end 
end

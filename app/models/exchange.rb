class Exchange < ActiveRecord::Base

    acts_as_rateable
    
	belongs_to :users, :foreign_key => "provider_id"
    belongs_to :users, :foreign_key => "recipient_id"
    
end

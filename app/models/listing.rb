class Listing < ActiveRecord::Base

	belongs_to :users
	has_one :exchanges
	has_and_belongs_to_many :colors
    has_one :listing_images
	
end

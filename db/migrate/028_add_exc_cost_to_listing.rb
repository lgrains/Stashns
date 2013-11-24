class AddExcCostToListing < ActiveRecord::Migration
	def self.up
		add_column :listings, :cost_of_exchange, :decimal
      
	end
	
	def self.down
		remove_column :listings, :cost_of_exchange
	end
end
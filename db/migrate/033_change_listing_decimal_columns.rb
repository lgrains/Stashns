class ChangeListingDecimalColumns < ActiveRecord::Migration
	def self.up
		change_column :listings, :cost_of_exchange, :decimal, :precision => 8, :scale => 2
		change_column :listings, :cost_per_yard, :decimal, :precision => 8, :scale => 2
		change_column :exchanges, :cost, :decimal, :precision => 8, :scale => 2
        
      
	end
	
	def self.down
		change_column :listings, :cost_of_exchange, :decimal
		change_column :listings, :cost_per_yard, :decimal
		change_column :exchanges, :cost, :decimal
	end
end
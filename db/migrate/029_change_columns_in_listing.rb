class ChangeColumnsInListing < ActiveRecord::Migration
	def self.up
		add_column :listings, :magazine_issue, :datetime
        
      
	end
	
	def self.down
		remove_column :listings, :magazine_issue
		
	end
end
class AddColumnsToExchange < ActiveRecord::Migration
	def self.up
		add_column :exchanges, :comments, :string
        add_column :exchanges, :funds_xfr, :boolean
        add_column :exchanges, :listing_id, :integer
      
	end
	
	def self.down
		remove_column :exchanges, :comments
        remove_column :exchanges, :funds_xfr
        remove_column :exchanges, :listing_id, :null => false
	end
end
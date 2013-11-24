class AddColumnsToListing < ActiveRecord::Migration
	def self.up
		add_column :listings, :color_list, :string
		add_column :listings, :fabric_type, :string
        add_column :listings, :pattern, :string
        add_column :listings, :theme, :string
      
	end
	
	def self.down
		remove_column :listings, :color_list
		remove_column :listings, :fabric_type
        remove_column :listings, :pattern
        remove_column :listings, :theme
	end
end
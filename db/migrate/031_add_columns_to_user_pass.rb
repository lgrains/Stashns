

class AddColumnsToUserPass < ActiveRecord::Migration
	def self.up
		add_column :users, :crypted_password, :string, :limit => 40
		add_column :users, :salt, :string, :limit => 40
		add_column :users, :remember_token, :string
		add_column :users, :remember_token_expires_at, :datetime
		add_column :users, :activation_code, :string, :limit => 40
		add_column :users, :activated_at, :datetime
		add_column :users, :login, :string
	end
	
	def self.down
		remove_column :users, :crypted_password
		remove_column :users, :salt
		remove_column :users, :remember_token
		remove_column :users, :remember_token_expires_at
		remove_column :users, :activation_code
		remove_column :users, :activated_at
		remove_column :users, :login
	end
end
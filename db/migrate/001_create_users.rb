class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
		t.column :email, :string
		t.column :address1, :string
		t.column :address2, :string
		t.column :city, :string
		t.column :state, :string
		t.column :country, :string
		t.column :postal_code, :string
		t.column :phone, :string
		t.column :created_on, :datetime
		t.column :updated_on, :datetime
		t.column :num_requests_filled, :integer
		t.column :num_request_made, :integer
    end
  end

  def self.down
    drop_table :users
  end
end

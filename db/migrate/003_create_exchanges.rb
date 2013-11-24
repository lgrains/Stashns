class CreateExchanges < ActiveRecord::Migration
  def self.up
    create_table :exchanges do |t|
		t.column :status, :string
		t.column :cost, :decimal
		t.column :created_on, :datetime
		t.column :updated_on, :datetime
		t.column :provider_id, :integer, :null=>false
		t.column :recipient_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :exchanges
  end
end

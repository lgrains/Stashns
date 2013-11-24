class CreateFabricsListings < ActiveRecord::Migration
  def self.up
    create_table :fabrics_listings, :id => false  do |t|
		t.column :listing_id, :integer
		t.column :fabric_id, :integer
    end
  end

  def self.down
    drop_table :fabrics_listings
  end
end

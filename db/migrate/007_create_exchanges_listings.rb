class CreateExchangesListings < ActiveRecord::Migration
  def self.up
    create_table :exchanges_listings, :id => false do |t|
		t.column :listing_id, :integer
		t.column :exchange_id, :integer
    end
  end

  def self.down
    drop_table :exchanges_listings
  end
end

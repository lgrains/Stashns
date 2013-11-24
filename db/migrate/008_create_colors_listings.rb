class CreateColorsListings < ActiveRecord::Migration
  def self.up
    create_table :colors_listings, :id => false  do |t|
		t.column :listing_id, :integer
		t.column :color_id, :integer
    end
  end

  def self.down
    drop_table :colors_listings
  end
end

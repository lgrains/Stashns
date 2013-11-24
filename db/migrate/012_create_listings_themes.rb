class CreateListingsThemes < ActiveRecord::Migration
  def self.up
    create_table :listings_themes, :id => false do |t|
		t.column :listing_id, :integer
		t.column :theme_id, :integer
    end
  end

  def self.down
    drop_table :listings_themes
  end
end

class CreateListingsPatterns < ActiveRecord::Migration
  def self.up
    create_table :listings_patterns, :id => false  do |t|
		t.column :listing_id, :integer
		t.column :pattern_id, :integer
    end
  end

  def self.down
    drop_table :listings_patterns
  end
end

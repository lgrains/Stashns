class CreateListings < ActiveRecord::Migration
  def self.up
    create_table :listings do |t|
		t.column :user_id, :integer, :null=>false
		t.column :type, :string
		t.column :listing_type, :string
		t.column :status, :string
		t.column :image_url, :string
		t.column :description, :string
		t.column :created_on, :datetime
		t.column :updated_on, :datetime
		
		#common attributes
		t.column :image_url, :string
		t.column :description, :string
		
		#attributes for yardage, blocks and quilt_tops
		t.column :length, :float
		t.column :width, :float
		
		#attributes for yardage only
		t.column :cost_per_yard, :decimal
		t.column :treated, :boolean
		t.column :treatment_method, :string
		t.column :manufacturer, :string
		t.column :fabric_line_name, :string
		t.column :fabric_designer, :string
		
		#attributes for blocks only
		t.column :number, :integer
		t.column :block_pattern_name, :string
		
		#attributes for kits
		t.column :complete, :boolean
		t.column :kit_pattern_included, :boolean
		t.column :kit_magazine_name, :string
		t.column :kit_magazine_issue, :datetime	#just show month and year of magazine
		t.column :finished_length, :float
		t.column :finished_width, :float
		
		#attributes for magazines
		t.column :magazine_name, :string
		t.column :magazine_month, :string
        t.column :magazine_year, :integer
    end
  end

  def self.down
    drop_table :listings
  end
end

class CreateListingImages < ActiveRecord::Migration
  def self.up
    create_table :listing_images do |t|
      t.column :listing_id, :integer
      t.column :original_filename, :string
      t.column :name, :string
      t.column :content_type, :string
      t.column :data, :binary, :limit => 2.megabyte
      t.column :created_on, :datetime
      t.column :updated_on, :datetime
    end

    
  end

  def self.down
    drop_table :listing_images
    
    
  end
end

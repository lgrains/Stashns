class CreatePatterns < ActiveRecord::Migration
  def self.up
    create_table :patterns do |t|
		t.column :pattern_type, :string
    end
  end

  def self.down
    drop_table :patterns
  end
end

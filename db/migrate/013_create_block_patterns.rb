class CreateBlockPatterns < ActiveRecord::Migration
  def self.up
    create_table :block_patterns do |t|
		t.column :name_of_pattern, :string
		t.column :block_url, :string
    end
  end

  def self.down
    drop_table :block_patterns
  end
end

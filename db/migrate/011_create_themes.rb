class CreateThemes < ActiveRecord::Migration
  def self.up
    create_table :themes do |t|
		t.column :name, :string
    end
  end

  def self.down
    drop_table :themes
  end
end

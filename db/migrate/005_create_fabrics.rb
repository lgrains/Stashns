class CreateFabrics < ActiveRecord::Migration
#includes types such as cotton, flannel, polyester, blend, fleece, Minkee, unknown
  def self.up
    create_table :fabrics do |t|
		t.column :fabric_type, :string
		
    end
  end

  def self.down
    drop_table :fabrics
  end
end

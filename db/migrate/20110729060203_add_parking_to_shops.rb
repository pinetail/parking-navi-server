class AddParkingToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :parking, :integer
  end

  def self.down
    remove_column :shops, :parking
  end
end

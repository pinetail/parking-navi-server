class AddCarToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :car, :integer
  end

  def self.down
    remove_column :shops, :car
  end
end

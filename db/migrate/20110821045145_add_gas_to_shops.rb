class AddGasToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :gas, :integer
  end

  def self.down
    remove_column :shops, :gas
  end
end

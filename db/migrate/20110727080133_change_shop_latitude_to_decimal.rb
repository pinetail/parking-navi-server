class ChangeShopLatitudeToDecimal < ActiveRecord::Migration
  def self.up
    change_column :shops, :latitude, :decimal, :precision => 17, :scale => 14,
    :default => 0.0
  end

  def self.down
    change_column :shops, :latitude, :float
  end
end

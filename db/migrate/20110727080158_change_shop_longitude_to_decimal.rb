class ChangeShopLongitudeToDecimal < ActiveRecord::Migration
  def self.up
    change_column :shops, :longitude, :decimal, :precision => 17, :scale => 14,
    :default => 0.0
  end

  def self.down
    change_column :shops, :longitude, :float
  end
end

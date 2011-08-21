class AddShowerToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :shower, :integer
  end

  def self.down
    remove_column :shops, :shower
  end
end

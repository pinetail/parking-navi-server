class AddBathRoomToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :bath_room, :integer
  end

  def self.down
    remove_column :shops, :bath_room
  end
end

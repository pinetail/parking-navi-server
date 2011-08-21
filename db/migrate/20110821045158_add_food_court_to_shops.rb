class AddFoodCourtToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :food_court, :integer
  end

  def self.down
    remove_column :shops, :food_court
  end
end

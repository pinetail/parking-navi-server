class AddRestaurantBusinessHoursToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :restaurant_business_hours, :string
  end

  def self.down
    remove_column :shops, :restaurant_business_hours
  end
end

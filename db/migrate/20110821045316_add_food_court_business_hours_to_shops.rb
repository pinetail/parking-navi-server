class AddFoodCourtBusinessHoursToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :food_court_business_hours, :string
  end

  def self.down
    remove_column :shops, :food_court_business_hours
  end
end

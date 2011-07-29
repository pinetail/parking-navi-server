class AddBabyBedToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :baby_bed, :integer
  end

  def self.down
    remove_column :shops, :baby_bed
  end
end

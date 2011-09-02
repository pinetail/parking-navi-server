class AddSsIdToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :ss_id, :string
  end

  def self.down
    remove_column :shops, :ss_id
  end
end

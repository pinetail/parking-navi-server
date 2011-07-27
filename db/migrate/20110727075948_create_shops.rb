class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.string :name
      t.string :address
      t.string :tel
      t.string :category
      t.string :uid
      t.float :latitude
      t.float :longitude
      t.string :parking_url
      t.string :road
      t.integer :information
      t.integer :shop
      t.integer :restaurant
      t.integer :park
      t.integer :rest_room
      t.text :memo
      t.integer :use_flg

      t.timestamps
    end
  end

  def self.down
    drop_table :shops
  end
end

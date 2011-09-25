class CreateShopsVisits < ActiveRecord::Migration
  def self.up
    create_table :shops_visits do |t|
      t.string :uuid
      t.integer :twitter_id
      t.string :shops_uid
      t.text :memo
      t.date :visited_at

      t.timestamps
    end
  end

  def self.down
    drop_table :shops_visits
  end
end

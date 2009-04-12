class CreateReserves < ActiveRecord::Migration
  def self.up
    create_table :reserves do |t|
      t.string :url

      t.boolean :visible,    :null => false, :default => true
      t.boolean :deleted,    :null => false, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :reserves
  end
end

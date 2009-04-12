class CreateVideos < ActiveRecord::Migration
  extend MigrationHelper

  def self.up
    create_table :videos do |t|
      t.references :reserve, :null => false
      t.string :name
      t.string :url

      t.boolean :visible,    :null => false, :default => true
      t.boolean :deleted,    :null => false, :default => false
      t.timestamps
    end

    add_index   :videos, :reserve_id, :name => 'reserve_id'
    foreign_key :videos, :reserve_id, :reserves
  end

  def self.down
    drop_table :videos
  end
end

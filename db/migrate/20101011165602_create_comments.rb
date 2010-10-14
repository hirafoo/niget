class CreateComments < ActiveRecord::Migration
  extend MigrationHelper

  def self.up
    create_table :comments do |t|
      t.references :video, :null => false
      t.string :content, :null => false, :default => ""

      t.boolean :visible,    :null => false, :default => true
      t.boolean :deleted,    :null => false, :default => false
      t.timestamps

      t.timestamps
    end

    add_index   :comments, :video_id, :name => 'video_id'
    foreign_key :comments, :video_id, :videos
  end

  def self.down
    drop_table :comments
  end
end

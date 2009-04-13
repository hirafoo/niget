class AddThumbnailUrlToVideo < ActiveRecord::Migration
  def self.up
    execute("alter table videos change column url video_url varchar(255) not null default '';")
    execute("alter table videos add thumbnail_url varchar(255) not null default '' after video_url;")
  end

  def self.down
    execute("alter table videos change column video_url url varchar(255) not null default '';")
    remove_column :videos, :thumbnail_url
  end
end

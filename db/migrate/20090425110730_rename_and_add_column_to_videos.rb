class RenameAndAddColumnToVideos < ActiveRecord::Migration
  def self.up
    rename_column :videos, :video_url, :url_economy
    execute("alter table videos add url_premium varchar(255) not null default '' after url_economy;")
  end

  def self.down
    rename_column :videos, :url_economy, :video_url
    remove_column :videos, :url_premium
  end
end

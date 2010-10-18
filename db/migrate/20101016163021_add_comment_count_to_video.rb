class AddCommentCountToVideo < ActiveRecord::Migration
  def self.up
    execute("alter table videos add comment_count integer not null default 0 after thumbnail_url;")
  end

  def self.down
    remove_column :videos, :comment_count
  end
end

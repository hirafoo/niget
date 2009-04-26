class AddIsPremiumToAccounts < ActiveRecord::Migration
  def self.up
    execute("alter table accounts add is_premium tinyint(1) not null default '0' after id;")
  end

  def self.down
    remove_column :accounts, :is_premium
  end
end

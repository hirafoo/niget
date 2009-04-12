class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :mail
      t.string :password

      t.boolean :visible,    :null => false, :default => true
      t.boolean :deleted,    :null => false, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end

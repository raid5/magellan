class AddDefaultToAuthentications < ActiveRecord::Migration
  def self.up
    add_column :authentications, :auth_default, :boolean, :default => false
  end

  def self.down
    remove_column :authentications, :auth_default
  end
end

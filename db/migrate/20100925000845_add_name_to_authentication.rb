class AddNameToAuthentication < ActiveRecord::Migration
  def self.up
    add_column :authentications, :name, :string
  end

  def self.down
    remove_column :authentications, :name
  end
end

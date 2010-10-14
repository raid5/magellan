class RemoveAuthenticationFromEndpoints < ActiveRecord::Migration
  def self.up
    remove_column :endpoints, :authentication_id
  end

  def self.down
    add_column :endpoints, :authentication_id, :integer
  end
end

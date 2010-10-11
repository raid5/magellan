class AddAuthenticationToEndpoints < ActiveRecord::Migration
  def self.up
    add_column :endpoints, :authentication_id, :integer
  end

  def self.down
    remove_column :endpoints, :authentication_id
  end
end

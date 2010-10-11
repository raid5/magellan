class AddNotesToEndpoints < ActiveRecord::Migration
  def self.up
    add_column :endpoints, :notes, :text
  end

  def self.down
    remove_column :endpoints, :notes
  end
end

class AddPTypeToParameters < ActiveRecord::Migration
  def self.up
    add_column :parameters, :p_type, :integer
  end

  def self.down
    remove_column :parameters, :p_type
  end
end

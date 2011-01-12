class AddParameterTypeToGlobalParameters < ActiveRecord::Migration
  def self.up
    add_column :global_parameters, :p_type, :integer, :default => 0
  end

  def self.down
    remove_column :global_parameters, :p_type
  end
end

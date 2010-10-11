class AddMethodToParameterSets < ActiveRecord::Migration
  def self.up
    add_column :parameter_sets, :http_method, :string
  end

  def self.down
    remove_column :parameter_sets, :http_method
  end
end

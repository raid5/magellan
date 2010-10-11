class AddDescriptionToParameters < ActiveRecord::Migration
  def self.up
    add_column :parameters, :description, :string
  end

  def self.down
    remove_column :parameters, :description
  end
end

class CreateParameters < ActiveRecord::Migration
  def self.up
    create_table :parameters do |t|
      t.string :name
      t.string :example
      t.boolean :required, :default => false
      t.references :parameter_set

      t.timestamps
    end
  end

  def self.down
    drop_table :parameters
  end
end

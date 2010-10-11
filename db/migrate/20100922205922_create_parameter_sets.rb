class CreateParameterSets < ActiveRecord::Migration
  def self.up
    create_table :parameter_sets do |t|
      t.string :name
      t.references :endpoint

      t.timestamps
    end
  end

  def self.down
    drop_table :parameter_sets
  end
end

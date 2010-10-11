class CreateResponseMembers < ActiveRecord::Migration
  def self.up
    create_table :response_members do |t|
      t.string :name
      t.string :description
      t.string :example
      t.references :parameter_set

      t.timestamps
    end
  end

  def self.down
    drop_table :response_members
  end
end

class CreateEndpoints < ActiveRecord::Migration
  def self.up
    create_table :endpoints do |t|
      t.string :name
      t.string :description
      t.string :url
      t.references :group

      t.timestamps
    end
  end

  def self.down
    drop_table :endpoints
  end
end

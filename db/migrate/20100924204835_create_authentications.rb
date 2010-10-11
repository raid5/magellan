class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.string :auth_method
      t.string :username
      t.string :password
      t.string :oauth_token

      t.timestamps
    end
  end

  def self.down
    drop_table :authentications
  end
end

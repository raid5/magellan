class AddAdditionalOAuthFieldsToAuthentications < ActiveRecord::Migration
  def self.up
    add_column :authentications, :consumer_key, :string
    add_column :authentications, :consumer_secret, :string
    add_column :authentications, :oauth_token_secret, :string
  end

  def self.down
    remove_column :authentications, :oauth_token_secret
    remove_column :authentications, :consumer_secret
    remove_column :authentications, :consumer_key
  end
end

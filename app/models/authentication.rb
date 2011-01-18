class Authentication < ActiveRecord::Base
  METHODS = {
    :basic => 'basic',
    :oauth => 'oauth'
  }
  
  validates_presence_of :auth_method
  validates_inclusion_of :auth_method, :in => METHODS.values
  
  validates_presence_of :name
  validates_uniqueness_of :name
end

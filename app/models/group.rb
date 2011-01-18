class Group < ActiveRecord::Base
  has_many :endpoints, :dependent => :destroy
  
  validates_presence_of :name
  validates_uniqueness_of :name
end

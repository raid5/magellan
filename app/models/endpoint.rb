class Endpoint < ActiveRecord::Base
  belongs_to :group
  has_many :parameter_sets, :dependent => :destroy
  
  validates_presence_of :name, :url
  validates_format_of :url, :with => /^(#{URI::regexp(%w(http https))})$/
end

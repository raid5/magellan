class Endpoint < ActiveRecord::Base
  belongs_to :group
  has_many :parameter_sets, :dependent => :destroy
  
  validates_presence_of :name, :url #, :http_method
  validates_format_of :url, :with => /^(#{URI::regexp(%w(http https))})$/
  #validates_inclusion_of :http_method, :in => %w( GET POST PUT DELETE )
end

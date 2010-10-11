class ParameterSet < ActiveRecord::Base
  belongs_to :endpoint
  has_many :parameters, :dependent => :destroy
  has_many :response_members, :dependent => :destroy
  
  HTTP_VERBS = %w( GET POST PUT DELETE )
  
  validates_presence_of :name, :http_method
  validates_inclusion_of :http_method, :in => HTTP_VERBS
end

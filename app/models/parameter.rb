class Parameter < ActiveRecord::Base
  belongs_to :parameter_set
  
  TYPES = {
    :parameter => 0,
    :header => 1,
    :url => 2
  }
  
  validates_presence_of :name, :p_type #:example
  validates_inclusion_of :p_type, :in => TYPES.values
  
  scope :params, where(:p_type => TYPES[:parameter])
  scope :headers, where(:p_type => TYPES[:header])
  scope :url_params, where(:p_type => TYPES[:url])
end

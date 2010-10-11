class ResponseMember < ActiveRecord::Base
  belongs_to :parameter_set
  
  validates_presence_of :name, :description, :example
end

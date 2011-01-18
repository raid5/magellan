class GlobalParameter < ActiveRecord::Base
  validates_presence_of :name, :value, :p_type
  validates_uniqueness_of :name
end

class GlobalParameter < ActiveRecord::Base
  validates_presence_of :name, :value, :p_type
  validates_uniqueness_of :name
  
  def type_name
    case p_type
    when Parameter::TYPES[:parameter] then "Global Standard Parameter"
    when Parameter::TYPES[:header] then "Global Header Parameter"
    when Parameter::TYPES[:url] then "Global URL Parameter"
    end
  end
  
  def parameter_key
    case p_type
    when Parameter::TYPES[:parameter] then "param-keys[]"
    when Parameter::TYPES[:header] then "header-keys[]"
    when Parameter::TYPES[:url] then "url-param-keys[]"
    end
  end
  
  def parameter_val
    case p_type
    when Parameter::TYPES[:parameter] then "param-vals[]"
    when Parameter::TYPES[:header] then "header-vals[]"
    when Parameter::TYPES[:url] then "url-param-vals[]"
    end
  end
end

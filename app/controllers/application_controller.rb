class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Uncomment to require HTTP Basic authentication for all actions except
  #  for exploring the API.
  
  before_filter :authenticate
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == 'raid5' && password == '73raidferdmag'
    end unless controller_name == 'endpoints' && action_name == 'show'
  end
end

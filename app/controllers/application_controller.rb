class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Uncomment to require HTTP Basic authentication for all actions except
  #  for exploring the API. Note: Make sure the two environment variables
  #  MAG_USERNAME and MAG_PASSWORD are defined.
  
  # before_filter :authenticate
  # 
  # def authenticate
  #   authenticate_or_request_with_http_basic do |username, password|
  #     username == ENV['MAG_USERNAME'] && password == ENV['MAG_PASSWORD']
  #   end unless controller_name == 'endpoints' && (action_name == 'show' || action_name == 'explore')
  # end
end

class HomeController < ApplicationController
  def index
    @auths = Authentication.all
    @auth_default = Authentication.find_by_auth_default(true)
    @global_params = GlobalParameter.all
    @groups = Group.includes(:endpoints).order("name")
    
    @has_endpoints = Endpoint.exists?
  end
end

class HomeController < ApplicationController
  def index
    @auths = Authentication.all
    @auth_default = Authentication.find_by_auth_default(true)
    @global_params = GlobalParameter.all
    @groups = Group.order("name")
    
    @has_endpoints = Endpoint.exists?
    #@explore_endpoint = params[:endpoint_id].blank? ? Endpoint.first : Endpoint.find(params[:endpoint_id])
  end
end

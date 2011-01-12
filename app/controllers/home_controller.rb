class HomeController < ApplicationController
  def index
    @auths = Authentication.all
    @global_params = GlobalParameter.all
    @groups = Group.order("name")
    
    @has_endpoints = Endpoint.exists?
    #@explore_endpoint = params[:endpoint_id].blank? ? Endpoint.first : Endpoint.find(params[:endpoint_id])
  end
end

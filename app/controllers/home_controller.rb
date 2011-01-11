class HomeController < ApplicationController
  def index
    @auths = Authentication.all
    @global_params = GlobalParameter.all
    @groups = Group.order("name")
    
    @explore_endpoint = params[:endpoint_id].blank? ? Endpoint.first : Endpoint.find(params[:endpoint_id])
  end
end

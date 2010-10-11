class HomeController < ApplicationController
  def index
    @groups = Group.all
    @explore_endpoint = params[:endpoint_id].blank? ? Endpoint.first : Endpoint.find(params[:endpoint_id])
  end
end

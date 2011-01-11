class ParameterSetsController < ApplicationController
  def show
    @parameter_set = ParameterSet.find(params[:id])
    @parameters = @parameter_set.parameters.params
    @headers = @parameter_set.parameters.headers
  end

  def new
    @endpoint = Endpoint.find(params[:endpoint_id])
    @parameter_set = @endpoint.parameter_sets.build
  end
  
  def create
    @endpoint = Endpoint.find(params[:endpoint_id])
    @parameter_set = @endpoint.parameter_sets.build(params[:parameter_set])
    
    if @parameter_set.save
      #redirect_to @parameter_set, :notice => "Parameter set created"
      redirect_to new_parameter_set_parameter_path(@parameter_set), :notice => "Parameter set created"
    else
      render :action => :new
    end
  end

  def edit
    @parameter_set = ParameterSet.find(params[:id])
  end

  def update
    @parameter_set = ParameterSet.find(params[:id])
    
    if @parameter_set.update_attributes(params[:parameter_set])
      redirect_to @parameter_set, :notice => "Parameter set updated"
    else
      render :action => :edit
    end
  end
  
  def destroy
    @parameter_set = ParameterSet.find(params[:id])
    endpoint = @parameter_set.endpoint
    @parameter_set.destroy
    redirect_to endpoint
  end
end

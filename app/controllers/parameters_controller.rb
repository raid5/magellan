class ParametersController < ApplicationController
  def new
    @parameter_set = ParameterSet.find(params[:parameter_set_id])
    @parameter = @parameter_set.parameters.build
  end
  
  def create
    @parameter_set = ParameterSet.find(params[:parameter_set_id])
    @parameter = @parameter_set.parameters.build(params[:parameter])
    
    if @parameter.save
      redirect_to @parameter_set, :notice => "Parameter created"
    else
      render :action => :new
    end
  end

  def edit
    @parameter = Parameter.find(params[:id])
  end
  
  def update
    @parameter = Parameter.find(params[:id])
    
    if @parameter.update_attributes(params[:parameter])
      redirect_to @parameter.parameter_set, :notice => "Parameter updated"
    else
      render :action => :edit
    end
  end

  def destroy
    @parameter = Parameter.find(params[:id])
    p_set = @parameter.parameter_set
    @parameter.destroy
    redirect_to p_set
  end
end

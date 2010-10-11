class GlobalParametersController < ApplicationController
  def index
    @global_params = GlobalParameter.all
  end

  def show
    @global_param = GlobalParameter.find(params[:id])
  end

  def new
    @global_param = GlobalParameter.new
  end
  
  def create
    @global_param = GlobalParameter.new(params[:global_parameter]) 
    
    if @global_param.save
      redirect_to global_parameters_path, :notice => "Global parameter created"
    else
      render :action => :new
    end
  end

  def edit
    @global_param = GlobalParameter.find(params[:id])
  end
  
  def update
    @global_param = GlobalParameter.find(params[:id])
    
    if @global_param.update_attributes(params[:global_parameter])
      redirect_to global_parameters_path, :notice => "Global parameter updated"
    else
      render :action => :edit
    end
  end
  
  def destroy
    @global_param = GlobalParameter.find(params[:id])
    @global_param.destroy
    redirect_to global_parameters_path
  end
end

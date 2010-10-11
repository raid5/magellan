class AuthenticationsController < ApplicationController
  def index
    @auths = Authentication.all
  end

  def show
    @auth = Authentication.find(params[:id])
  end

  def new
    @auth = Authentication.new
  end
  
  def create
    @auth = Authentication.new(params[:authentication]) 
    
    if @auth.save
      redirect_to authentications_path, :notice => "Authentication created"
    else
      render :action => :new
    end
  end

  def edit
    @auth = Authentication.find(params[:id])
  end
  
  def update
    @auth = Authentication.find(params[:id])
    
    if @auth.update_attributes(params[:authentication])
      redirect_to @auth, :notice => "Authentication updated"
    else
      render :action => :edit
    end
  end
  
  def destroy
    @auth = Authentication.find(params[:id])
    @auth.destroy
    redirect_to authentications_path
  end
end

class AuthenticationsController < ApplicationController
  def index
    @auths = Authentication.all
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
      # Reset previous default if needed
      if @auth.auth_default?
        Authentication.update_all "auth_default = 0", "id != #{@auth.id}"
      end
      
      redirect_to authentications_path, :notice => "Authentication updated"
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

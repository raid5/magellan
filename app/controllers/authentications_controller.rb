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
      if @auth.auth_method == 'oauth'
        # Create OAuth Consumer
        consumer = consumer_from_params(params)
      
        # Save some data in the session
        # p request.env.inspect
        request_token = consumer.get_request_token(:oauth_callback => "http://#{request.env['HTTP_HOST']}/oauth/callback")
        session[:request_token] = request_token
        session[:authentication_id] = @auth.id
        
        # Authorize
        redirect_to request_token.authorize_url
      else
        # Basic auth created
        redirect_to authentications_path, :notice => "HTTP Basic authentication created"
      end
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
  
  def callback
    # Request access token
    request_token = session[:request_token]
    access_token = request_token.get_access_token
    
    # Save access token to authentication
    @auth = Authentication.find(session[:authentication_id])
    
    # Cleanup session
    session[:request_token] = nil
    session[:authentication_id] = nil
    
    if @auth.update_attributes(:oauth_token => access_token.token, :oauth_token_secret => access_token.secret)
      redirect_to authentications_path, :notice => "OAuth authentication created"
    else
      redirect_to authentications_path, :alert => "Unable to save OAuth data to authentication"
    end
  end
  
  private
  
  def consumer_from_params(params)
    options = { :site => params[:base_url] }
    options[:request_token_path] = params[:request_token_path] unless params[:request_token_path].blank?
    options[:authorize_path] = params[:authorize_path] unless params[:authorize_path].blank?
    options[:access_token_path] = params[:access_token_path] unless params[:access_token_path].blank?
    
    OAuth::Consumer.new(params[:authentication][:consumer_key], params[:authentication][:consumer_secret], options)
  end
end

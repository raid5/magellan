class ResponseMembersController < ApplicationController
  def index
  end

  def show
  end

  def new
    @parameter_set = ParameterSet.find(params[:parameter_set_id])
    @response_member = @parameter_set.response_members.build
  end
  
  def create
    @parameter_set = ParameterSet.find(params[:parameter_set_id])
    @response_member = @parameter_set.response_members.build(params[:response_member])
    
    if @response_member.save
      redirect_to @parameter_set, :notice => "Response member created"
    else
      render :action => :new
    end
  end

  def edit
    @response_member = ResponseMember.find(params[:id])
    #@parameter_set = @response_member.parameter_set
  end
  
  def update
    @response_member = ResponseMember.find(params[:id])
    
    if @response_member.update_attributes(params[:response_member])
      redirect_to @response_member.parameter_set, :notice => "Response member updated"
    else
      render :action => :edit
    end
  end
  
  def destroy
    @response_member = ResponseMember.find(params[:id])
    
    p_set = @response_member.parameter_set
    @response_member.destroy
    redirect_to p_set
  end
end

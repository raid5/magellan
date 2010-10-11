class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end
  
  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(params[:group]) 
    
    if @group.save
      redirect_to @group, :notice => "Group created"
    else
      render :action => :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end
  
  def update
    @group = Group.find(params[:id])
    
    if @group.update_attributes(params[:group])
      redirect_to @group, :notice => "Group updated"
    else
      render :action => :edit
    end
  end
  
  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path
  end
end

class UpdateController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create, :edit, :delete]
    
  def index
    @project = Project.find(params[:project_id])
    @updates = @project.updates
  end

  def new
    @project = Project.find(params[:project_id])
  end

  def create
    @update = Update.new update_params
    @update.save
    redirect_to action: "index"
  end

  def show
  	@update = Update.find(params[:id])
  end

  def update
  	@update = Update.find(params[:id])
  end

  def destroy
  	Update.find(params[:id]).destroy
  	redirect_to action: "index"
  end

  def update_params
    params.permit(:title, :url, :description, :project_id)
  end
end

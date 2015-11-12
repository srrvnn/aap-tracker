class ProjectController < ApplicationController
  helper ProjectHelper
    
  def index
    @projects = Project.all
  end

  def new
  	@project = Project.new
    @statuses = Project::STATUSES
  end

  def create
    @project = Project.new project_params
    @project.save
    redirect_to action: "index"
  end

  def show
  	@project = Project.find(params[:id])
    @updates = @project.updates
  end

  def edit
    @project = Project.find(params[:id])
    @statuses = Project::STATUSES
  end

  def update
  	@project = Project.find(params[:id])
  	@project.update_attributes project_params
    redirect_to action: "index"
  end

  def destroy
  	Project.find(params[:id]).destroy
  	redirect_to action: "index"
  end
  
  def project_params
    params.require(:project).permit(:sno, :title, :description, :status)
  end
end

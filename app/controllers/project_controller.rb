class ProjectController < ApplicationController
  helper ProjectHelper
    
  def index
    @projects = Project.all
    @num_total = Project.count
    @num_in_progress = Project.where("status = ?", Project::STATUSES["In Progress"]).count
    @num_partially_fulfilled = Project.where("status = ?", Project::STATUSES["Partially Fulfilled"]).count
    @num_fulfilled = Project.where("status = ?", Project::STATUSES["Fulfilled"]).count

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
  	Project.delete(params[:id])
  	redirect_to action: "index"
  end
  
  def project_params
    params.require(:project).permit(:sno, :title, :description, :status)
  end
end

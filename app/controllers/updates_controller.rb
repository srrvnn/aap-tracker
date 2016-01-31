class UpdatesController < ApplicationController
    before_action :current_user, only: [:new, :create, :edit, :delete]

  def index
    redirect_to project_path(params[:project_id])
  end

  def new
    @project = Project.find(params[:project_id])
    @update = Update.new
  end

  def edit
    @update = Update.find(params[:id])
    @project = Project.find(params[:project_id])
  end

  def create
    @update = Update.new update_params
    # @update.official = current_user.offical
    @update.save
    redirect_to project_path(update_params[:project_id])
  end

  def show
    redirect_to project_path(params[:project_id])
  end

  def update
  	@update = Update.find(params[:id])
    @update.update_attributes update_params
    redirect_to project_path(update_params[:project_id])
  end

  def destroy
  	Update.find(params[:id]).destroy
  	redirect_to action: "index"
  end

  def update_params
    params.require(:update).permit(:title, :url, :description, :project_id)
  end
end

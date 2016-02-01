require 'pp'

class UpdatesController < ApplicationController
    before_action :check_access, only: [:index, :new, :create, :edit, :delete]

  def index
    @updates = Update.order(:created_at)
    # redirect_to project_path(params[:project_id])
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
    if verify_recaptcha(model: @update)
      @update.save
    end
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
    params.require(:update).permit(:title, :url, :official, :description, :project_id)
  end

  protected
  def check_access
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    redirect_to projects_path and return unless (@current_user && @current_user.volunteer)
  end

end

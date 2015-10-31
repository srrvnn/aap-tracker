class UpdateController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    @updates = @project.updates
  end

  def new

  end

  def create
    @update = Update.new
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

end

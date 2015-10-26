class ProjectController < ApplicationController
  def index
    @projects = Project.all
  end

  def new
  	@project = Project.new
  	# retrieve data from form
  end

  def create

  end


  # view a single project detail page
  def view
  	@project = Project.find(params[:id])
  end

  def update
  	@project = Project.find(params[:id])
  	# TODO:
  end

  def delete
  	Project.find(params[:id]).destroy
  	redirect_to action: "index"
  end

end

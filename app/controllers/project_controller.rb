class ProjectController < ApplicationController
  def index
    @projects = Project.all
  end

  def new
  	@project = Project.new
    @project.sno = params[:sno]
    @project.title = params[:title]
    @project.description = params[:description]
    @project.save
    redirect_to action: "index"
  end

  def create

  end


  # view a single project detail page
  def view
  	@project = Project.find(params[:id])
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
  	@project = Project.find(params[:id])
  	@project.sno = params[:sno]
    @project.title = params[:title]
    @project.description = params[:description]
    @project.save
    redirect_to action: "index"
  end

  def delete
  	Project.find(params[:id]).destroy
  	redirect_to action: "index"
  end

end

class ProjectsController < ApplicationController
  helper ProjectsHelper

  def landing
    @data = [
        {
            value: 27,
            color: "#46BFBD",
            highlight: "#5AD3D1",
            label: "Promises with Positive Public Responses"
        },
        {
            value: 43,
            color:"#ECECEC",
            highlight: "#F6F6F6",
            label: "Others"
        }
    ]
    @options = {
      animation: false
    }
  end

  def index
    @projects = Project.order(:sno)

    if params[:search].present?
      @projects = Project.where("description LIKE ?", "%#{params[:search]}%").order(:sno)
    end

    @count = {}

    @count["total"] = @projects.count
    @count["uninitiated"] = @projects.where("status = ?", Project::STATUSES["Not Started"]).count
    @count["initiated"] = @projects.where("status = ?", Project::STATUSES["In Progress"]).count
    @count["blocked"] = @projects.where("status = ?", Project::STATUSES["Partially Fulfilled"]).count
    @count["fulfilled"] = @projects.where("status = ?", Project::STATUSES["Fulfilled"]).count

    @percent = {}

    @percent["uninitiated"] = @count["total"] == 0 ? 0 : @count["uninitiated"] * 100 / @count["total"]
    @percent["initiated"] = @count["total"] == 0 ? 0 : @count["initiated"] * 100 / @count["total"]
    @percent["blocked"] = @count["total"] == 0 ? 0 : @count["blocked"] * 100 / @count["total"]
    @percent["fulfilled"] = @count["total"] == 0 ? 0 : @count["fulfilled"] * 100 / @count["total"]

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

    if params[:sort].present?
      @updates = @project.updates.order('event_occured ' + params[:sort])
    else
      @updates = @project.updates.order('event_occured DESC')
    end
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

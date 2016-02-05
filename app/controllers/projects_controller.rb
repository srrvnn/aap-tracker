class ProjectsController < ApplicationController
  helper ProjectsHelper
  before_action :check_user
  before_action :check_access, only: [:edit, :delete, :new, :create, :destroy]

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

    @data = {
      labels: ["January", "February", "March", "April", "May", "June", "July"],
      datasets: [
          {
              label: "Official Responses",
              fillColor: "rgba(151,187,205,0.2)",
              strokeColor: "rgba(151,187,205,1)",
              pointColor: "rgba(151,187,205,1)",
              pointStrokeColor: "#fff",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(151,187,205,1)",
              data: [28, 48, 40, 19, 86, 27, 90]
          }
      ]
    }
    @options = {
      animation: false,
      width: 840
    }

    if params[:search].present?
      @projects = Project.where("description LIKE ?", "%#{params[:search]}%").order(:sno)
    end

    if params[:category].present?
      @projects = @projects.where("status = ?", Project::STATUSES[params[:status]])
    end

    if params[:status].present?
      @projects = @projects.where("status = ?", Project::STATUSES[params[:status]])
    end

    @count = {}

    @count["total"] = @projects.count
    @count["uninitiated"] = @projects.where("status = ?", Project::STATUSES["Not Started"]).count
    @count["initiated"] = @projects.where("status = ?", Project::STATUSES["In Progress"]).count
    @count["blocked"] = @projects.where("status = ?", Project::STATUSES["Partially Fulfilled"]).count
    @count["fulfilled"] = @projects.where("status = ?", Project::STATUSES["Fulfilled"]).count

    @percent = {}

    @percent["initiated"] = @count["total"] == 0 ? 0 : @count["initiated"] * 100 / @count["total"]
    @percent["blocked"] = @count["total"] == 0 ? 0 : @count["blocked"] * 100 / @count["total"]
    @percent["fulfilled"] = @count["total"] == 0 ? 0 : @count["fulfilled"] * 100 / @count["total"]

    # calculate the left over to avoid errors due to round off
    @percent["uninitiated"] = @count["total"] == 0 ? 0 : 100 - @percent["initiated"] - @percent["blocked"] - @percent["fulfilled"]
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

    @updates = @updates.select{|u| u.official || (u.votes_for.up.size > 2 && (u.created_at < DateTime.now - 7))}

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

  protected
  def check_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def check_access
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    redirect_to root_path and return unless (@current_user && @current_user.volunteer)
  end
end

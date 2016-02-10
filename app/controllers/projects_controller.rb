require 'pp'

class ProjectsController < ApplicationController

  helper ProjectsHelper
  before_action :check_user
  before_action :check_access, only: [:edit, :delete, :new, :create, :destroy]

  def landing

    @updates_all_per_project = Update.group("project_id").count

    @updates_positive = Update.where(positive: true).order(:project_id)
    @updates_postive_approved = @updates_positive.select{|u| u.count_votes_up > 2}
    @updates_postive_approved_per_project = {}
    @updates_postive_approved.chunk{|u| u.project_id }.each{ |project, ary| @updates_postive_approved_per_project[project] = ary.count }

    # @updates_all_per_project = {4 => 10, 5 => 10}
    # @updates_postive_approved_per_project = {4 => 6, 5 => 9}

    @projects_success = @updates_all_per_project.count{ |p| (@updates_postive_approved_per_project[p[0]] ||= 0) * 2 > p[1] }


    @count = {}

    @projects = Project.order(:sno)
    @count["total"] = @projects.count
    @count["uninitiated"] = @projects.where("status = ?", Project::STATUSES["Not Started"]).count
    @count["initiated"] = @projects.where("status = ?", Project::STATUSES["In Progress"]).count
    @count["blocked"] = @projects.where("status = ?", Project::STATUSES["Partially Fulfilled"]).count
    @count["fulfilled"] = @projects.where("status = ?", Project::STATUSES["Fulfilled"]).count

    @percent = {}

    @percent["initiated"] = @count["total"] == 0 ? 0 : @count["initiated"] * 100 / @count["total"]
    @percent["blocked"] = @count["total"] == 0 ? 0 : @count["blocked"] * 100 / @count["total"]
    @percent["fulfilled"] = @count["total"] == 0 ? 0 : @count["fulfilled"] * 100 / @count["total"]
    @percent["uninitiated"] = @count["total"] == 0 ? 0 : 100 - @percent["initiated"] - @percent["blocked"] - @percent["fulfilled"]

    @doughnut_data = [
        {
            value: @count["fulfilled"] + @count["blocked"],
            color: "#46BFBD",
            highlight: "#5AD3D1",
            label: "Promises Kept"
        },
        # {
        #     value: @count["blocked"],
        #     color: "#428BCA",
        #     highlight: "#619ed3",
        #     label: "Partially Fulfilled Promises"
        # },
        {
            value: @count["initiated"],
            color: "#e8d806",
            highlight: "#faeb2f",
            label: "Work in Progress"
        },
        {
            value: @count["uninitiated"],
            color:"#ECECEC",
            highlight: "#F6F6F6",
            label: "To Be Started Promises"
        }
    ]

    @doughtnut_options = {

      animation: false
    }

    @last_sunday = Date.today.beginning_of_week(:sunday)
    @last_last_sunday = Date.today.beginning_of_week(:sunday) - 7.days

    @this_week = {

      projects_with_updates: Update.where("official = ? AND created_at > ?", true, @last_sunday).group("project_id").count.count,
      official_updates: Update.where("official = ? AND created_at > ?", true, @last_sunday).count,
      public_all_updates: Update.where("official = ? AND created_at > ?", false, @last_last_sunday)
    }

    if @this_week["public_all_updates"].nil? then
      puts "all updates nil"
      @this_week[:public_updates] = 0
      @this_week[:irrelevant_updates] = 0
    else
      @this_week[:public_updates] = @this_week["public_all_updates"].select{|u| u.count_votes_up > 2}.count
      @this_week[:irrelevant_updates] = @this_week["public_all_updates"].select{|u| u.count_votes_down > 2}.count
    end

  end

  def index

    @projects = Project.order(:sno)

    if params[:search].present?
      @projects = Project.where("LOWER(description) LIKE LOWER(?)", "%#{params[:search]}%").order(:sno)
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

    # stuff for the graph

    @data = {
      labels: ["FEB 2015"],
      datasets: [
          {
              label: "Number of Official Responses over time.",
              fillColor: "rgba(151,187,205,0.2)",
              strokeColor: "rgba(151,187,205,1)",
              pointColor: "rgba(151,187,205,1)",
              pointStrokeColor: "#fff",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(151,187,205,1)",
              data: [0]
          }
      ]
    }

    @options = {
      animation: false,
      width: 840,
      generateLegend: true
    }

    # compute numbers

    @project_ids = @projects.map { |r| r["id"] }
    @updates = Update.where(project_id: @project_ids)
    @updates = @updates.select{|u| u.official}

    no_of_windows = 6
    day1 = DateTime.parse("14-02-2015")
    dayn = DateTime.current

    no_of_days = (dayn - day1).to_i
    period = no_of_days / no_of_windows

    for i in 1..no_of_windows do
      window_start = (day1 + (period * (i-1)).days)
      window_end = (day1 + (period * i).days)
      window_count = @updates.select{|u|
        u.event_occured > window_start && u.event_occured < window_end}.count

      @data[:labels].push(window_end.to_time.strftime('%^b %Y'))
      @data[:datasets][0][:data].push(window_count)
    end

    window_count = @updates.select{|u|
      (u.event_occured > (day1 + period * no_of_windows)) && u.event_occured < dayn}.count

    @data[:labels].push("TODAY")
    @data[:datasets][0][:data].push(window_count)

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
    redirect_to root_path and return unless (@current_user && @current_user.official)
  end
end


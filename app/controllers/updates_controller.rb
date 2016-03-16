require 'pp'

class UpdatesController < ApplicationController
    before_action :check_user
    before_action :check_volunteer_access, only: [:index, :delete, :approve, :reject]
    before_action :check_official_access, only: [:edit]

  def index

    @upvoted_updates = @current_user.find_up_voted_items
    @downvoted_updates = @current_user.find_down_voted_items
    @new_updates = Update.where(official: false) - @upvoted_updates - @downvoted_updates

    # @upvoted_updates = @upvoted_updates.select{|u|
    #   u.created_at > DateTime.now - 120.minutes}

    # @downvoted_updates = @downvoted_updates.select{|u|
    #   u.created_at > DateTime.now - 120.minutes}

    @updates = (@new_updates + @upvoted_updates + @downvoted_updates)


    # redirect_to project_path(params[:project_id])
  end

  def new
    @project = Project.find(params[:project_id])

    @update = Update.new
    @update.project = @project

    @statuses = Project::STATUSES
  end

  def edit
    @update = Update.find(params[:id])
    @project = Project.find(params[:project_id])
  end

  def approve

    @update = Update.find(params[:id])

    puts case @current_user.voted_as_when_voted_for @update
    when true
      @update.unliked_by @current_user
    when false
      @update.liked_by @current_user
    when nil
      @update.liked_by @current_user
    end

    flash[:notice] = "Response updated successfully. You have 2 hours to change your choice."
    redirect_to updates_path
  end

  def reject

    @update = Update.find(params[:id])

    puts case @current_user.voted_as_when_voted_for @update

    when true
      @update.disliked_by @current_user
    when false
      @update.undisliked_by @current_user
    when nil
      @update.disliked_by @current_user
    end

    flash[:notice] = "Response updated successfully. You have 2 hours to change your choice."
    redirect_to updates_path
  end

  def create
    @update = Update.new update_params
    @project = Project.find(params[:project_id])

    if verify_recaptcha(model: @update)

      if @current_user && @current_user.official
        @update.positive = true
        @update.official = true
        @project.update_attribute(:status, params[:update][:project][:status])
      end

      @update.save
    end

    unless @current_user && @current_user.official
      flash[:notice] = "Response successfully saved. Will appear here, after moderation in 7 days."
    end

    redirect_to project_path(update_params[:project_id])
  end

  def show
    redirect_to project_path(params[:project_id])
  end

  def update
  	@update = Update.find(params[:id])
    if verify_recaptcha(model: @update)
      if @current_user && @current_user.official
        @update.update_attributes update_params
      end
    end
    redirect_to project_path(update_params[:project_id])
  end

  def destroy
  	Update.find(params[:id]).destroy
  	redirect_to action: "index"
  end

  def update_params
    params.require(:update).permit(:title, :url, :official, :positive, :description, :project_id, :event_occured)
  end

  protected

  def check_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def check_volunteer_access
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    redirect_to root_path and return unless (@current_user && @current_user.volunteer)
  end

  def check_official_access
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    redirect_to root_path and return unless (@current_user && @current_user.official)
  end

end

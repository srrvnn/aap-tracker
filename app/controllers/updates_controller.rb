require 'pp'

class UpdatesController < ApplicationController
    before_action :check_user
    before_action :check_access, only: [:index, :edit, :delete, :approve, :reject]

  def index

    @upvoted_updates = @current_user.find_up_voted_items
    @downvoted_updates = @current_user.find_down_voted_items
    @new_updates = Update.where(official: false) - @upvoted_updates - @downvoted_updates

    @updates = (@new_updates + @upvoted_updates + @downvoted_updates)

    # @updates = Update.where(official: false)

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

    if @current_user.voted_as_when_voted_for @update
      @update.unliked_by @current_user
    else
      @update.upvote_from @current_user
    end

    # @approved_count = @update.approved_count
    # @update.update_attributes(approved_count: @approved_count + 1)

    redirect_to updates_path
  end

  def reject

    @update = Update.find(params[:id])

    if @current_user.voted_as_when_voted_for @update
      @update.downvote_from @current_user
    else
      @update.undisliked_by @current_user
    end

    # @rejected_count = @update.rejected_count
    # @update.update_attributes(rejected_count: @rejected_count + 1)

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
    params.require(:update).permit(:title, :url, :official, :positive, :description, :project_id, :event_occured)
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

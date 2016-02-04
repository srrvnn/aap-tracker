require 'pp'

class UsersController < ApplicationController
    before_action :check_access, only: [:index, :official, :volunteer]

  def index
  	@friends = get_friends().map { |r| r["id"] }
    @users = User.where(uid: @friends)
  end

  def official
    if @current_user.official then
      user = User.find(params[:id])
      user.official = !user.official
      user.save!
    end

    redirect_to users_path
  end

  def volunteer
    if @current_user.volunteer then
      user = User.find(params[:id])
      user.volunteer = !user.volunteer
      user.save!
    end

    redirect_to users_path
  end

  protected
  def check_access
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    redirect_to root_path and return unless (@current_user && (@current_user.volunteer || @current_user.official))
  end

  private
  def get_friends
  	_friends = Koala::Facebook::API.new(session[:user_oauth]).get_connections("me", "friends")
  end
end

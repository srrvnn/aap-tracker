require 'pp'

class SessionsController < ApplicationController
	def create
	   user = User.from_omniauth(env["omniauth.auth"])
	   session[:user_id] = user.id
	   session[:user_oauth] = user.oauth_token

	   # puts 'IN SESSION:'
	   # puts '-----------'

	   # pp session[:user_oauth]

	   redirect_to root_url
	 end

	 def destroy
	   session[:user_id] = nil
	   redirect_to root_url
	 end
end

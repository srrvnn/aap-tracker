class Update < ActiveRecord::Base

	acts_as_votable
  	belongs_to :project
end

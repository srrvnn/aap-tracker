class Update < ActiveRecord::Base

	acts_as_votable
  	belongs_to :project
  	accepts_nested_attributes_for :project
end

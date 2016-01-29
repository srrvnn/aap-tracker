class Update < ActiveRecord::Base

	# default_scope { order('updated_at DESC') }
  	belongs_to :project
end

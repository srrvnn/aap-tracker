class UpdateController < ApplicationController

  def index
    @project = Project.find(params[:id])
    @updates = @project.updates
  end

end

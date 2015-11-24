module ProjectsHelper
  def format_status(status)
    status ? Project::STATUS_STRINGS[status] : 'Not Started'
  end
  
  def status_color(status)
    status ? Project::STATUS_COLORS[status] : 'red'
  end
  
end

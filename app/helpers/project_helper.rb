module ProjectHelper
  def format_status(status)
    status ? Project::STATUS_STRINGS[status] : 'Not Started'
  end
end

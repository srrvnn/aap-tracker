class Project < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_many :updates
  validates :sno, uniqueness: true
  
  STATUSES = { 'Not Started' =>1, 'In Progress' =>2, 'Completed' =>3 }
  
  STATUS_STRINGS = { 1=> 'Not Started', 2 => 'In Progress', 3 => 'Completed' }
  
end

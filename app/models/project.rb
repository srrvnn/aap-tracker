class Project < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_many :updates
  validates :sno, uniqueness: true
  
  STATUSES = { 'Not Started' =>1, 'In Progress' =>2, 'Partially Fulfilled' =>3, 'Fulfilled' =>4  }
  
  STATUS_STRINGS = { 1=> 'Not Started', 2 => 'In Progress', 3 => 'Partially Fulfilled', 4 => 'Completed' }
  
  STATUS_COLORS = { 1=> 'red', 2 => 'yellow', 3 => 'blue', 4 => 'green' }
  
end

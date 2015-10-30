class Project < ActiveRecord::Base
  has_and_belongs_to_many :categories
  validates :sno, uniqueness: true
end

class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :project_assignments
end

class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :project_assignments, dependent: :destroy
  has_many :users, through: :project_assignments

  accepts_nested_attributes_for :tasks, allow_destroy: true, reject_if: :all_blank
end

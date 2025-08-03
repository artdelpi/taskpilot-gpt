class Task < ApplicationRecord
  belongs_to :project
  has_many :attachments, dependent: :destroy
  has_many :task_assignments, dependent: :destroy
  has_many :users, through: :task_assignments
  has_many :comments, dependent: :destroy
  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags

  # Dependências diretas
  has_many :task_dependencies, foreign_key: :task_id, dependent: :destroy
  has_many :dependencies, through: :task_dependencies, source: :depends_on_task

  # Dependências inversas
  has_many :inverse_task_dependencies, class_name: "TaskDependency", foreign_key: :depends_on_task_id, dependent: :destroy
  has_many :dependents, through: :inverse_task_dependencies, source: :task
end

class User < ApplicationRecord
    belongs_to :project
    has_many :task_assignments, dependent: :destroy
    has_many :tasks, through :task_assignments
    has_many :comments, dependent: :destroy
end

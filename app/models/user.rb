class User < ApplicationRecord
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    has_many :project_assignments
    has_many :projects, through: :project_assignments
    has_many :task_assignments, dependent: :destroy
    has_many :tasks, through: :task_assignments
    has_many :comments, dependent: :destroy
end

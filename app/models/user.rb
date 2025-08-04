class User < ApplicationRecord
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    belongs_to :project
    has_many :task_assignments, dependent: :destroy
    has_many :tasks, through: :task_assignments
    has_many :comments, dependent: :destroy
end

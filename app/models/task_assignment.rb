class TaskAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validate :user_must_be_in_project

  private
  def user_must_be_in_project
    return if task&.project&.users&.exists?(id: user_id)
    errors.add(:user, "must belong to the task's project")
  end
end

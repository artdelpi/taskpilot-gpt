class TaskDependency < ApplicationRecord
  belongs_to :task
  belongs_to :depends_on_task, class_name: "Task"
end

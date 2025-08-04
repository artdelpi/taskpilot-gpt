class TaskAssignmentsController < ApplicationController
  def create
    @task_assignment = TaskAssignment.new(task_assignment_params)
    if @task_assignment.save
      redirect_to @task_assignment.task
    else
      render :new
    end
  end

  def destroy
    @task_assignment = TaskAssignment.find(params[:id])
    @task_assignment.destroy
    redirect_to @task_assignment.task
  end

  private

  def task_assignment_params
    params.require(:task_assignment).permit(:task_id, :user_id, :role, :due_date)
  end
end

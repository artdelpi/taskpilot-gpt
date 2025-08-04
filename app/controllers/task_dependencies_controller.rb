class TaskDependenciesController < ApplicationController
  def create
    @task_dependency = TaskDependency.new(task_dependency_params)
    if @task_dependency.save
      redirect_to @task_dependency.task
    else
      render :new
    end
  end

  def destroy
    @task_dependency = TaskDependency.find(params[:id])
    @task_dependency.destroy
    redirect_to @task_dependency.task
  end

  private

  def task_dependency_params
    params.require(:task_dependency).permit(:task_id, :depends_on_task_id)
  end
end

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.joins(project: :users)
                 .where(users: { id: current_user.id })
                 .includes(:project)
                 .order(created_at: :desc)
  end

  def show
    @tasks = @project.tasks.order(created_at: :desc) 
  end
  
  def create
    @task = @project.tasks.build(task_params)
    if @task.save
      redirect_to project_path(@project), notice: "Task created."
    else
      @members = @project.users
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @task = @project.tasks.build
    @members = @project.users
  end

  def edit
    @members = @project.users
  end

  def update
    if @task.update(task_params)
      redirect_to project_path(@project), notice: "Task updated."
    else
      @members = @project.users
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "Task deleted."
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def set_task
    @task = Task.joins(project: :users)
                .where(users: { id: current_user.id })
                .find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :priority, :due_date, :status, :project_id)
  end
end

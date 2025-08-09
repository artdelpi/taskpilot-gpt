class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @projects = current_user.projects
    @project  = Project.new            
    @project.tasks.build
  end

  def show
    @project = current_user.projects
                         .includes(:tasks)
                         .find(params[:id])
    @tasks = @project.tasks.order(created_at: :desc)
  end

  def new
    @project = Project.new
    @project.tasks.build
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      ProjectAssignment.create!(user: current_user, project: @project)
      redirect_to authenticated_root_path, notice: "Project created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to @project
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_path
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :name, :description,
      tasks_attributes: [:id, :title, :description, :due_date, :priority, :status, :_destroy]
    )
  end

  def generate_ai_tasks
    service = OpenAIPlanner.new
    prompt  = @project.description.to_s

    tasks = service.suggest_tasks(@project.name, prompt) 

    created = []
    ActiveRecord::Base.transaction do
      tasks.each do |t|
        created << @project.tasks.create!(
          title:       t["title"],
          description: t["description"],
          due_date:    t["due_date"],
          status:      "pending",
          priority:    t["priority"] || "normal"
        )
      end
    end

    render json: { created: created.map { |x| { id: x.id, title: x.title } } }, status: :created
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end

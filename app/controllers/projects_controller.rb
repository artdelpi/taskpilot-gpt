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

  def generate_ai_tasks
    @project = current_user.projects.find(params[:id])

    tasks = Ai::TaskGenerator.new(@project).call(count: params[:count].to_i.clamp(1, 15).presence || 5)

    @created = []
    ApplicationRecord.transaction do
      tasks.each do |attrs|
        @created << @project.tasks.create!(attrs.merge(status: "pending"))
      end
    end

    respond_to do |format|
      format.turbo_stream 
      format.json { render json: { created: @created.as_json(only: [:id, :title, :due_date]) } }
    end
  rescue => e
    Rails.logger.error("[AI] generate_ai_tasks failed: #{e.message}")
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash", locals: { alert: "AI generation failed" }), status: :unprocessable_entity }
      format.json { render json: { error: "AI generation failed" }, status: :unprocessable_entity }
    end
  end

  def suggest_ai_tasks
    name = params[:name].to_s
    description = params[:description].to_s
    count = params[:count].to_i.clamp(1, 15).presence || 5

    fake_project = OpenStruct.new(name: name, description: description)
    tasks = Ai::TaskGenerator.new(fake_project).call(count: count)

    render json: { tasks: tasks }
  rescue => e
    Rails.logger.error("[AI] suggest_ai_tasks failed: #{e.message}")
    render json: { error: "AI suggestion failed" }, status: :unprocessable_entity
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

end

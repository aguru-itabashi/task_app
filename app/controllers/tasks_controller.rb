class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
<<<<<<< HEAD

=======
  
>>>>>>> 52deb249321d5d7acb25ee2654d3d262da00ddeb
  def index
  	@tasks = Task.recent
  end

  def new
  	@task = Task.new
  end

  def create
  	task = current_user.tasks.new(task_params)
  	if task.save!
  	  redirect_to tasks_url, notice: "タスク「#{task.name}」を登録しました"
    else
      render "new"
    end
  end

  def show; end

  def edit; end


  def update
  	@task.update!(task_params)
  	redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました"
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}を削除しました」"
  end

  private

  def task_params
  	params.require(:task).permit(:name, :description)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end

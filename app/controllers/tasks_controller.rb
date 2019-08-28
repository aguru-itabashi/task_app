class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @task = Task.new
    @q = current_user.tasks.ransack(params[:q])
    #distinct: trueで重複を避ける
    # @tasks = @q.result(distinct: true).recent

    @tasks = @q.result(distinct: true).recent.page(params[:page])

    respond_to do |format|
      format.html
      format.js
      format.csv {send_data @tasks.generate_csv, filename: "tasks-#{Time.zone.now.strftime('%Y%m%d')}.csv"}
    end
  end

  def new
  	@task = Task.new
  end

  # def confirm_new
  #   @task = current_user.tasks.build(task_params)
  #   render "new" if @task.invalid?
  # end

  def create
    @task = current_user.tasks.build(task_params)
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).recent.page(params[:page])
    # if params[:back]
    #   render "new"
    #   return
    # end
    if @task.save
      # TaskMailer.creation_email(@task).deliver_now
      # SampleJob.perform_later
      respond_to do |format|
        format.js{render :create}
        # redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました"
      end
    else
      render "new"
    end
  end

  def show; end

  def edit; end


  def update
  	@task.update(task_params)
  	redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました"
  end

  def destroy
    if @task.destroy
      # @q = current_user.tasks.ransack(params[:q])
      # @tasks = @q.result(distinct: true).recent.page(params[:page])
      respond_to do |format|
        format.js{render :destroy}
      end
    end

    # redirect_to tasks_url, notice: "タスク「#{@task.name}を削除しました」"
  end

  def import
    current_user.tasks.import(params[:file])
    redirect_to tasks_url, notice: "タスクを追加しました"
  end

  private

  def task_params
  	params.require(:task).permit(:name, :description)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end

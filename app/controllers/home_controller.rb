class HomeController < ApplicationController
  before_action :redirect_user

  def index
    @lists = List.includes(:tasks).where(user_id: current_user.id)
  end

  def new
    @list = List.new
  end

  def create
    list = List.new(title: params[:title], category: params[:category], user_id: current_user.id)

    if list.save
      params[:tasks].each do |task_params|
        Task.create(description: task_params[:description], checked: task_params[:checked], list_id: list.id)
      end
      redirect_to root_path
    else
      redirect_to :new, alert: 'Erro ao criar lista.'
    end
  end

  def edit
    @list = List.includes(:tasks).find(params[:id])
  end

  def update
    list = List.includes(:tasks).find(params[:id])
  
    if list.update(title: params[:list][:title], category: params[:list][:category])
      params[:list][:tasks].values.each do |task_params|
        task = Task.find(task_params[:id])
        task.update(description: task_params[:description], checked: task_params[:checked])
      end
      redirect_to root_path
    else
      redirect_to edit_home_path(list), alert: 'Erro ao atualizar lista.'
    end
  end  

  def destroy
    List.find(params[:id]).destroy
    redirect_to root_path
  end

  private

  def redirect_user
    redirect_to new_user_session_path unless user_signed_in?
  end
end

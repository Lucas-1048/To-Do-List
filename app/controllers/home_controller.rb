class HomeController < ApplicationController
  before_action :redirect_user

  def index
    if params[:date]
      @lists = List.includes(:tasks).where(date: params[:date], user_id: current_user.id)

      if params[:category]
        @lists = @lists.where(category: params[:category])
      end
    else
      @today_lists = List.includes(:tasks).where(date: Date.today, user_id: current_user.id)
      @tomorrow_lists = List.includes(:tasks).where(date: Date.tomorrow, user_id: current_user.id)

      if params[:category]
        @today_lists = @today_lists.where(category: params[:category])
        @tomorrow_lists = @tomorrow_lists.where(category: params[:category])
      end
    end
  end

  def new
    @list = List.new
    @list.date = params[:date]
  end

  def create
    list_params = params.require(:list).permit(:title, :category, :date)
    list = List.new(list_params.merge(user_id: current_user.id))

    if list.title.blank?
      redirect_to new_home_path, alert: "O título da lista não pode estar em branco."
      return
    end

    if params[:list][:tasks].values.all? { |task| task[:description].blank? }
      redirect_to new_home_path, alert: "A lista deve conter pelo menos uma tarefa."
      return
    end

    if list.save
      params[:list][:tasks].values.each do |task_params|
        Task.create(list_id: list.id, checked: task_params[:checked], description: task_params[:description])
      end
      if list.date != Date.today && list.date != Date.tomorrow
        redirect_to root_path(date: list.date)
      else
        redirect_to root_path
      end
    else
      redirect_to new_home_path, alert: "Erro ao criar lista."
    end
  end

  def edit
    @list = List.includes(:tasks).find(params[:id])
  end

  def update
    list = List.find(params[:id])

    if list.title.blank?
      redirect_to edit_home_path(list), alert: "O título da lista não pode estar em branco."
      return
    end

    if params[:list][:tasks].values.all? { |task| task[:description].blank? }
      redirect_to edit_home_path(list), alert: "A lista deve conter pelo menos uma tarefa."
      return
    end

    if list.update(title: params[:list][:title], category: params[:list][:category])
      params[:list][:tasks].values.each do |task_params|
        task = list.tasks.find_by(id: task_params[:id])
        task.update(description: task_params[:description], checked: task_params[:checked])
      end
      if list.date != Date.today && list.date != Date.tomorrow
        redirect_to root_path(date: list.date)
      else
        redirect_to root_path
      end
    else
      redirect_to edit_home_path(list), alert: "Erro ao atualizar lista."
    end
  end

  def destroy
    List.find(params[:id]).destroy
    redirect_to root_path
  end

  def set_personal
    @lists = List.includes(:tasks).where(user_id: current_user.id, category: "personal")
  end

  def set_work
    @lists = List.includes(:tasks).where(user_id: current_user.id, category: "work")
  end

  def set_study
    @lists = List.includes(:tasks).where(user_id: current_user.id, category: "study")
  end

  private

  def redirect_user
    redirect_to new_user_session_path unless user_signed_in?
  end
end

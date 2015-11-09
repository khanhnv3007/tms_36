class Supervisors::UserSubjectsController < ApplicationController
  before_action :find_user_subject, only: [:show]

  def show
    @user_tasks = current_user.user_tasks
  end

  private
  def find_user_subject
    @user_subject = UserSubject.find params[:id]
  end
end

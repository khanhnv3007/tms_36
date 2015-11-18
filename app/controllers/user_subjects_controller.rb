class UserSubjectsController < ApplicationController
  before_action :find_user_subject, only: [:show, :update]

  def show
    @user_tasks = @user_subject.user_tasks
    @activities = Activity.by_user_subject(@user_subject)
      .recent.paginate page: params[:page]
  end

  def update
    @user_subject.finish_subject
    flash.now[:success] = t "flashs.course.update"
    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end

  private
  def find_user_subject
    @user_subject = UserSubject.find params[:id]
  end
end

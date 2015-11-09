class Supervisors::UserCoursesController < ApplicationController
  before_action :authorize_user
  before_action :authorize_supervisor
  before_action :find_user_course, except: [:new, :create]

  def index
    @users = User.all.paginate page: params[:page]
  end

  def show
    @user = User.find params[:user_id]
    @user_subjects = @user.user_subjects
  end

  private
  def find_user_course
    @user_course = UserCourse.find params[:id]
  end
end

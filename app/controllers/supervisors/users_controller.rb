class Supervisors::UsersController < ApplicationController
  before_action :authorize_user
  before_action :authorize_supervisor
  before_action :find_user, except: [:new, :create, :index]

  def index
    @users = User.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def destroy
    if @user.destroy
      flash[:success] = t "flashs.user.del"
      redirect_to supervisors_users_url
    else
      flash[:success] = t "flashs.user.del_error"
      redirect_to supervisors_users_url
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "flashs.user.signup"
      redirect_to root_path
    else
      flash.now[:danger] = t "flashs.user.error_signup"
      render :new
    end
  end

  def show
    @user_courses = @user.user_courses
  end

  def edit
    if @user.is_supervisor && !current_user?(@user)
      redirect_back_or root_url
      flash[:danger] = t "flashs.user.show"
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "flashs.user.edit"
      redirect_to supervisors_user_url @user
    else
      flash.now[:danger] = t "flashs.user.error_edit"
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :is_supervisor
  end

  def find_user
    @user = User.find params[:id]
  end
end

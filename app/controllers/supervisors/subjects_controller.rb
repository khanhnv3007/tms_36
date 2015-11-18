class Supervisors::SubjectsController < ApplicationController
  before_action :find_subject, except: [:new, :create, :index]
  before_action :authorize_user
  before_action :authorize_supervisor

  def index
    @subjects = Subject.recent.paginate page: params[:page]
  end

  def new
    @subject = Subject.new
    @subject.tasks.build
  end

  def show
    if params[:course_id]
      @course = Course.find params[:course_id]
      @course_subject =
        @subject.course_subjects.find_by course_id: @course.id
    end
  end

  def edit
    @subject.tasks.build unless @subject.tasks.any?
  end

  def create
    @subject = Subject.new subject_params
    if @subject.save
      flash[:success] = t "flashs.subject.created"
      redirect_to [:supervisors, @subject]
    else
      flash.now[:danger] = t "flashs.subject.error_created"
      @subject.tasks.build
      render :new
    end
  end

  def update
    if @subject.update_attributes subject_params
      flash[:success] = t "flashs.subject.updated"
      redirect_to [:supervisors, @subject]
    else
      flash.now[:danger] = t "flashs.subject.error_updated"
      render :edit
    end
  end

  private
  def find_subject
    @subject = Subject.find params[:id]
  end

  def subject_params
    params.require(:subject).permit :name, :description, :status,
      :start_date, :end_date,
      tasks_attributes: [:id, :name, :description, :_destroy]
  end
end

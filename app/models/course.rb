class Course < ActiveRecord::Base
  include StateAble
  include LogAble

  enum status: {started: 0, finished: 1}

  has_many :user_courses, dependent: :destroy, inverse_of: :course
  has_many :users, through: :user_courses
  has_many :course_subjects
  has_many :subjects, through: :course_subjects

  validates :name, presence: true, length: {maximum: 50}
  validates :description, presence: true, length: {maximum: 1000}
  validates :status, presence: true

  after_update :update_subjects_status, :update_user_courses_status

  accepts_nested_attributes_for :user_courses, allow_destroy: true,
    reject_if: proc { |attributes| attributes['user_id'].blank? }
  accepts_nested_attributes_for :course_subjects, allow_destroy: true,
    reject_if: proc { |attributes| attributes['subject_id'].blank? }

  private
  def update_subjects_status
    unless self.course_subjects.nil?
      self.course_subjects.each do |course_subject|
        self.finished? ? course_subject.update_status(:finished) :
        course_subject.update_status(:started)
      end
    end
  end

  def update_user_courses_status
    if self.user_courses.present?
      self.user_courses.each{|user_course| user_course.update_status self.status}
    end
  end
end

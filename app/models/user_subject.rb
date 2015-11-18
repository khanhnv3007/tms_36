class UserSubject < ActiveRecord::Base
  include StateAble
  include LogAble
  enum status: {started: 0, finished: 1}

  user_courses = "(select id from user_courses where course_id = ?)"
  scope :by_course_id, ->course_id{where "user_course_id in #{user_courses}",
    course_id}

  belongs_to :user
  belongs_to :subject
  belongs_to :user_course
  has_many :user_tasks, dependent: :destroy

  after_create :create_user_tasks
  after_update :log_activity, :update_user_tasks_status

  private
  def finish_subject
    if self.update_status :finished
      user_tasks.each{|user_task| user_task.update_status :finished}
    end
  end

  def create_user_tasks
    if self.subject.started? && self.subject.tasks.present?
      self.subject.tasks.each do |task|
        self.user_tasks.create(user_id: self.user.id, task_id: task.id,
          status: :started)
      end
    end
  end

  def update_user_tasks_status
    if self.user_tasks.present?
      self.user_tasks.each{|user_task| user_task.update_status self.status}
    end
  end
end

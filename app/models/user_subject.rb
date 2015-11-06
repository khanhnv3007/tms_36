class UserSubject < ActiveRecord::Base
  include StateAble
  enum status: {started: 0, finished: 1}

  belongs_to :user
  belongs_to :subject
  belongs_to :user_course
  has_many :user_tasks

  def finish_subject
    if self.update_status :finished
      user_tasks.each{|user_task| user_task.update_status :finished}
    end
  end
end

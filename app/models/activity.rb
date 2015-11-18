class Activity < ActiveRecord::Base
  belongs_to :user

  scope :recent, ->{order created_at: :desc}
  scope :by_target, ->target{where "target_type = ? and target_id = ?",
    target.class.name, target.id}
  scope :by_user_subject, ->user_subject{where "(target_type = 'UserSubject' \
    and target_id = :id) or (target_type = 'UserTask' and target_id in \
    (select id from user_tasks where user_subject_id = :id))",
    id: user_subject.id}

  def target
    self.target_type.constantize.find_by_id self.target_id
  end
end

class Feedback < ActiveRecord::Base

  default_scope { where('updated_at > ?', 30.minutes.ago) }

  scope :outdated, -> { unscoped.where('updated_at < ?', 30.minutes.ago) }

  validates :linedir, :udid, presence: true

  enum status: { on_time: 0, early: 1, late: 2, very_late: 3, cancelled: 4 }

end

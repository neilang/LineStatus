class Feedback < ActiveRecord::Base

  validates :linedir, :udid, presence: true

  enum status: { on_time: 0, early: 1, late: 2, very_late: 3, cancelled: 4 }

end

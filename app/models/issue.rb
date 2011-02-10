class Issue < ActiveRecord::Base
  
  # == Validations ==========================================================
  
  validates :area_id,
    :presence => true
  
  validates :number,
    :uniqueness => true
  
  validate :scheduled_time_is_ahead
  
  # == Relationships ========================================================
  
  belongs_to :area, 
    :counter_cache => true
  
  has_many :posts,
    :dependent => :destroy

  # == Scopes ===============================================================

  scope :last_sent, order(:sent_at)
  
  # == Callbacks ============================================================
  
  before_create :set_issue_number
  after_create  :check_area_send_mode
  
  # == Instance Methods =====================================================
  
  def send!
    UserMailer.new_issue(self).deliver
    self.update_attribute(:sent_at, Time.now)
  end
  
protected
  def scheduled_time_is_ahead
    if self.scheduled_at.present? && (self.scheduled_at < Time.now)
      errors.add(:scheduled_at, "can't be in the past.")
    end
  end
  
  def set_issue_number
    self.number = self.area.issue_number.next
  end
  
  def check_area_send_mode
    self.send! if self.area.send_mode?(:immediate)
  end
end

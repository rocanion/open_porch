class Issue < ActiveRecord::Base
  
  # == Validations ==========================================================
  
  validates :area_id,
    :presence => true
  
  validates :number,
    :uniqueness => { :scope => :area_id }
  
  validate :scheduled_time_is_ahead
  
  # == Relationships ========================================================
  
  belongs_to :area, 
    :counter_cache => true
  
  has_many :posts,
    :dependent => :destroy

  # == Scopes ===============================================================
  
  scope :sent, where('sent_at IS NOT NULL')

  scope :scheduled_before, lambda { |t| 
    where(['sent_at IS NULL AND scheduled_at <= ?', t.utc])
  }
  
  scope :in_month, lambda { |m|
    where(["to_char(sent_at, 'YYYY-MM') = ?", m])
  }

  # == Callbacks ============================================================
  
  before_create :set_issue_number
  
  # == Instance Methods =====================================================
  
  def send!
    UserMailer.new_issue(self).deliver
    
    self.update_attribute(:sent_at, Time.now.utc)
    
    # Create a new issue for the area if there are any new posts left
    if self.area.posts.in_issue(nil).count > 0
      self.area.issues.create
    end
    
    self.area.record_activity_for!(:issues_published)
  end
  
  def to_params
    self.number
  end
  
protected
  def scheduled_time_is_ahead
    if self.scheduled_at.present? && (self.scheduled_at < Time.now.utc)
      errors.add(:scheduled_at, "can't be in the past.")
    end
  end
  
  def set_issue_number
    self.number ||= self.area.issue_number.next
  end
end

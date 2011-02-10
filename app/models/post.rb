class Post < ActiveRecord::Base

  # == Validations ==========================================================
  
  validates :title, :content, :area_id, :user_id,
    :presence => true
    
  # == Relationships ========================================================
  
  belongs_to :area
  belongs_to :user
  belongs_to :issue
  
  # == Callbacks ============================================================

  after_create :create_issue

  # == Scope ================================================================
  
  scope :in_issue, lambda { |issue| where(:issue_id => issue) }

  # == Instance Methods =====================================================

  def reviewed?
    self.reviewed_by.present?
  end

protected
  def create_issue
    if self.area.send_mode?(:immediate)
      self.issue = self.area.issues.create
      self.save
    elsif self.area.send_mode?(:batched) && self.area.current_issue.blank?
      self.area.issues.create
    end
  end
end

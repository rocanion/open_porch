class Post < ActiveRecord::Base

  # == Validations ==========================================================
  
  validates :title, :content, :area_id, :user_id,
    :presence => true
    
  # == Relationships ========================================================
  
  belongs_to :area
  belongs_to :user
  belongs_to :issue
  belongs_to :email_message
  
  # == Callbacks ============================================================

  after_create :create_issue, :record_activity_for_new_post

  # == Scope ================================================================
  
  scope :in_issue, lambda { |issue| where(:issue_id => issue) }

  # == Instance Methods =====================================================

  def reviewed?
    self.reviewed_by.present?
  end

protected
  def create_issue
    if self.area.send_mode?(:immediate)
      self.issue = self.area.issues.create!
      self.save
      self.issue.reload
      self.issue.send! 
    elsif self.area.send_mode?(:batched) && self.area.current_issue.blank?
      self.area.issues.create
    end
  end
  
  def record_activity_for_new_post
    self.area.record_activity_for!(:new_posts)
  end
end

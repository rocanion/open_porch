class Post < ActiveRecord::Base

  # == Validations ==========================================================
  
  validates :title, :content, :area_id, :user_id,
    :presence => true
    
  # == Relationships ========================================================
  
  belongs_to :area
  belongs_to :user
  belongs_to :issue
  belongs_to :reviewed_by,
    :class_name => 'User',
    :foreign_key => :reviewed_by_id
  
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
    end
  end
end

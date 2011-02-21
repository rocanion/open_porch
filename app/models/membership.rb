class Membership < ActiveRecord::Base

  # == Validations ==========================================================
  
  validates :user_id,
    :uniqueness => { :scope => :area_id }
  
  # == Relationships ========================================================
  
  belongs_to :user
  belongs_to :area, 
    :counter_cache => true

  # == Callbacks ============================================================
  
  after_create :record_activity_for_new_users
  after_destroy :record_activity_for_quitters
  
protected
  def record_activity_for_new_users
    self.area.record_activity_for!(:new_users)
  end
  
  def record_activity_for_quitters
    self.area.record_activity_for!(:quitters)
  end
end
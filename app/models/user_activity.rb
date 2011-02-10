class UserActivity < ActiveRecord::Base
  
  # == Constants ============================================================

   EXPIRES = 5 # in seconds
  
  # == Relationships ========================================================
  
  validates :name, :url,
    :presence => true
  
  # == Scopes ===============================================================
  
  scope :active_for_page, lambda {|name, url|
    where(
      "expires_at >= ? AND name != ? AND url = ?",
      Time.now, name, url
    )
  }
  
  # == Callbacks ============================================================
  
  after_create :set_expiration!
  
  # == Instance Methods =====================================================
  
  def set_expiration!
    self.update_attribute(:expires_at, Time.now.advance(:seconds => EXPIRES))
  end
  
end

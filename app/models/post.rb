class Post < ActiveRecord::Base

  # == Validations ==========================================================
  
  validates :title, :content, :area_id, :user_id,
    :presence => true
    
  # == Relationships ========================================================
  
  belongs_to :area
  belongs_to :user

  # == Callbacks ============================================================

  after_create :send_post

  # == Instance Methods =====================================================

  def send_post
    UserMailer.new_post(self).deliver
  end
  
end

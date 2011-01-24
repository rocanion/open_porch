class Membership < ActiveRecord::Base

  # == Validations ==========================================================
  
  validates :area_id,
    :presence => true
  
  validates :user_id,
    :presence => true,
    :uniqueness => { :scope => :area_id }
  
  # == Relationships ========================================================
  
  belongs_to :user
  belongs_to :area
  
end
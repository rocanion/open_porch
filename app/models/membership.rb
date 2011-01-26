class Membership < ActiveRecord::Base

  # == Validations ==========================================================
  
  validates :user_id,
    :uniqueness => { :scope => :area_id }
  
  # == Relationships ========================================================
  
  belongs_to :user
  belongs_to :area
  
end
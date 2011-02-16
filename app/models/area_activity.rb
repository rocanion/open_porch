class AreaActivity < ActiveRecord::Base
  
  # == Relationships ========================================================
  
  belongs_to :area
  
  # == Validations ==========================================================
  
  validates :day,
    :presence => true
  validates :area_id,
    :presence => true,
    :uniqueness => {:scope => :day}

end

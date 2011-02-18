class AreaActivity < ActiveRecord::Base
  
  TRACKABLE = %w(quitters new_users new_posts issues_published).freeze
  
  # == Relationships ========================================================
  
  belongs_to :area
  
  # == Validations ==========================================================
  
  validates :day,
    :presence => true
  validates :area_id,
    :presence => true,
    :uniqueness => {:scope => :day}

  # == Scopes ===============================================================
  
  default_scope order('day ASC')
  
  scope :grouped_by_day,
    select([['day'] + TRACKABLE.collect{|a| "sum(#{a}_count) as sum_#{a}_count"}].join(', ')).group(:day)

end

class User < ActiveRecord::Base
  
  # == Relationships ========================================================
  
  has_many :memberships,
    :dependent => :destroy
  has_many :areas,
    :through => :memberships
  
end

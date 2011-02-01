class Area < ActiveRecord::Base
  
  # == Attributes ===========================================================
  
  # == Constants ============================================================
  
  # == Extensions ===========================================================
  
  # == Relationships ========================================================
  
  has_many :memberships,
    :dependent => :destroy
  has_many :users,
    :through => :memberships
  has_many :posts,
    :dependent => :destroy
  
  # == Validations ==========================================================
  
  validates :name,
    :presence => {:message => 'Please enter the name of this area'}
  validates :slug,
    :presence => true,
    :uniqueness  => true
  
  # == Scopes ===============================================================
  
  scope :closest_from, lambda {|point, distance| 
    where("ST_DWithin(border, ST_GeomFromEWKT('SRID=4326;POINT(#{point.text_representation})'), #{distance})").
    order("ST_Distance(border, ST_GeomFromEWKT('SRID=4326;POINT(#{point.text_representation})'))")
  }
  
  # == Callbacks ============================================================
  
  # == Class Methods ========================================================
  
  # == Instance Methods =====================================================
  
  # Returns a Point object
  def center
    if self.border.present?
      border.envelope.center
    end
  end
  
  def border_coordinates
    @border_coordinates ||= border.rings.first.points.collect{|point| "new google.maps.LatLng(#{point.x}, #{point.y})"}.join(',')
  end
  
end

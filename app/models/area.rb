class Area < ActiveRecord::Base
  # == Constants ============================================================

  # == Extensions ===========================================================

  # == Relationships ========================================================

  # == Validations ==========================================================

  validates :name,
    :presence => {:message => 'Please enter the name of this area'}
  validates :slug,
    :presence => true,
    :uniqueness  => true

  # == Scopes ===============================================================
  
  scope :closest_from, lambda {|point, distance| 
    where("ST_DWithin(border, ST_GeomFromText('SRID=4326;POINT(#{point.text_representation})'), #{distance})")
  }
  # == Callbacks ============================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================
  
  # Returns a Point object
  def center
    border.envelope.center
  end
  
  def border_coordinates
    @border_coordinates ||= border.rings.first.points.collect{|point| "new google.maps.LatLng(#{point.x}, #{point.y})"}.join(',')
  end
  
end

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

  # == Callbacks ============================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================
  
  def border_coordinates
    @border_coordinates ||= border.rings.first.points.collect{|point| "new google.maps.LatLng(#{point.x}, #{point.y})"}.join(',')
  end
  
end

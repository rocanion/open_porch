class Area < ActiveRecord::Base
  
  # == Attributes ===========================================================
  
  attr_accessor :coordinates
  
  # == Constants ============================================================
  
  # == Extensions ===========================================================
  
  # == Relationships ========================================================
  
  has_many :memberships,
    :dependent => :destroy
  has_many :users,
    :through => :memberships
  
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
  
  def coordinates=(points)
    if points.present?
      raw = self.coordinates.split(/\r\n*/).collect{|c| [c.split(/,/)[0].to_f, c.split(/,/)[1].to_f]}
      self.border = Polygon.from_coordinates([raw])
    end
  end
  
  def coordinates
    if self.border.present?
      self.border.first.points.collect{|p| "#{p.x},#{p.y}"}.join("\r\n")
    end
  end
  
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

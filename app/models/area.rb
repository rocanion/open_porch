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
  has_one :issue_number,
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
  
  after_create :initialize_issue_numbers
  
  # == Class Methods ========================================================
  
  # == Instance Methods =====================================================
  
  def coordinates=(points)
    coords = points.collect{|k, v| [v[0].to_f, v[1].to_f]}
    self.border = Polygon.from_coordinates([coords + [coords.first]])
  end
  
  def coordinates
    if self.border.present?
      self.border.first.points.collect{|p| "#{p.x},#{p.y}"}.join("\r\n")
    end
  end
  
  # Returns an array with coordinates
  # removing the last (repeated) point
  def to_a
    if self.border.present?
      {
        :id => self.id,
        :points => self.border.first.points[0..-2].collect{|p| [p.x, p.y]}
      }
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
  
protected
  def initialize_issue_numbers
    self.create_issue_number(:sequence_number => 0)
  end
end

class Area < ActiveRecord::Base
  
  # == Attributes ===========================================================
  
  # == Constants ============================================================
  
  SEND_MODES = {
    :immediate  => 0,
    :batched    => 1
  }.freeze
  
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
  has_many :issues,
    :dependent => :destroy
  has_many :activities,
    :dependent => :destroy,
    :class_name => 'AreaActivity'
  
  # == Validations ==========================================================
  
  validates :name,
    :presence => {:message => 'Please enter the name of this area'}
  validates :slug,
    :uniqueness  => true,
    :format => { :with => /^[A-Za-z0-9_-]+$/ },
    :allow_nil => true
  validates :send_mode,
    :presence => true,
    :inclusion => SEND_MODES.values
    
  # == Scopes ===============================================================
  
  scope :closest_from, lambda {|point, distance| 
    where("ST_DWithin(border, ST_GeomFromEWKT('SRID=4326;POINT(#{point.text_representation})'), #{distance})").
    order("ST_Distance(border, ST_GeomFromEWKT('SRID=4326;POINT(#{point.text_representation})'))")
  }
  
  # == Callbacks ============================================================
  
  after_create :initialize_issue_numbers
  
  # == Class Methods ========================================================
  
  # Return a hash with the form {area_id => posts.count}
  def self.newposts_count
    connection.select_rows("
      SELECT area_id, COUNT(posts.id) 
      FROM posts LEFT JOIN areas ON (posts.area_id = areas.id)
      WHERE issue_id IS NULL
      GROUP BY area_id
    ").inject({}){|h, count| h[count[0].to_i] = count[1].to_i; h}
  end
  
  # == Instance Methods =====================================================
  
  def coordinates=(points)
    coords = points.collect{|k, v| [v[0].to_f, v[1].to_f]}
    self.border = Polygon.from_coordinates([coords + [coords.first]])
  end
  
  
  # Returns an array with coordinates
  # removing the last (repeated) point
  def to_a
    if self.border.present?
      {
        :id => self.id,
        :name => self.name,
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
  
  def bounds
    return [] unless self.border.present?
    [
      [self.border.envelope.lower_corner.x, self.border.envelope.lower_corner.y],
      [self.border.envelope.upper_corner.x, self.border.envelope.upper_corner.y]
    ]
  end
  
  def border_coordinates
    @border_coordinates ||= border.rings.first.points.collect{|point| "new google.maps.LatLng(#{point.x}, #{point.y})"}.join(',')
  end
  
  def send_mode?(mode)
    self.send_mode.to_i == SEND_MODES[mode]
  end
  
  def location
    [self.city, self.state].compact.join(', ')
  end
  
  def send_mode_name
    SEND_MODES.invert[self.send_mode]
  end
  
  def current_issue
    self.issues.where(:sent_at => nil).first
  end
  
  def record_activity_for!(field)
    activity = self.activities.find_or_create_by_day(Time.now.utc.to_date)
    activity.increment!([field, 'count'].join('_'))
    activity.reload
  end
  
protected
  def initialize_issue_numbers
    self.create_issue_number(:sequence_number => 0)
  end
end

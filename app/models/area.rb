class Area < ActiveRecord::Base
  
  # == Constants ============================================================
  
  SEND_MODES = %w{immediate batched}
  
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
    :format => { :with => /^[\w.-]+$/ },
    :allow_nil => true
  validates :send_mode,
    :presence => true,
    :inclusion => SEND_MODES
    
  # == Scopes ===============================================================
  
  scope :closest_from, lambda {|point, distance| 
    where("ST_DWithin(border, ST_GeomFromEWKT('SRID=4326;POINT(#{point.text_representation})'), #{distance})").
    order("ST_Distance(border, ST_GeomFromEWKT('SRID=4326;POINT(#{point.text_representation})'))")
  }
  
  # Search Scope
  scope :full_name_search,
    lambda {|str|
      like_str = "%#{str}%"
      id = str
      where("((name || ', ' || city || ', ' || state) ILIKE ?)", like_str)
    }

  if defined?(MetaSearch)
    search_methods :full_name_search
  end
  
  # == Callbacks ============================================================
  
  before_validation :set_send_mode, :on => :create
  after_create :initialize_issue_numbers
  after_save :check_send_mode_change, :on => :update
  
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
  
  def location
    [self.city, self.state].compact.join(', ')
  end
  
  def current_issue
    @current_issue ||= self.issues.where(:sent_at => nil).first
  end
  
  def send_mode?(mode)
    self.send_mode == mode.to_s
  end
  
  def record_activity_for!(field)
    field = field.to_s
    if AreaActivity::TRACKABLE.include?(field)
      activity = self.activities.find_or_create_by_day(Time.now.utc.to_date)
      activity.increment!([field, 'count'].join('_'), 1)
      activity.reload
    else
      raise "Cannot find field in the list of trackable fields. Currently tracking: #{AreaActivity::TRACKABLE.join(', ')}"
    end
  end
  
  def self.for_select
    Area.order('state, city, name').collect{|a| [[a.name, a.city, a.state].join(', '), a.id]}
  end
  
  def email
    if defined?(OPEN_PORCH_POP3)
      "#{self.slug}@#{OPEN_PORCH_POP3['mailto']}"
    end
  end
  
  # afr.php returns HTML code
  def openx_ad(zone_name)
    return unless defined?(OPEN_PORCH_ZONES)
    time = Time.now.to_i
    openx_url = "http://d1.openx.org"

    case zone_name.to_sym
    when :newsletter_text
      url = URI.parse(openx_url)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.get("/afr.php?zoneid=#{OPEN_PORCH_ZONES[zone_name.to_s]}&region=#{self.slug}&cb=#{time}&n=a8417ca6")
      }
      res.body.gsub("\n", '').gsub(/.*<body>(.*)<div id='beacon.*/, '\1').html_safe
    else
      %{
        <a href="#{openx_url}/ck.php?cb=#{time}&n=a8417ca6", class="ad #{zone_name}" target="_blank">
          <img src="http://d1.openx.org/avw.php?zoneid=#{OPEN_PORCH_ZONES[zone_name.to_s]}&region=#{self.slug}&cb=#{time}&n=a8417ca6" />
        </a>
      }.html_safe
    end
  end
  
  
protected
  def initialize_issue_numbers
    self.create_issue_number(:sequence_number => 0)
  end
  
  def set_send_mode
    self.send_mode ||= 'immediate'
  end
  
  def check_send_mode_change
    # Detach any posts from the current issue
    if self.send_mode_changed? && self.send_mode?(:immediate)
      if self.current_issue
        self.current_issue.posts.each do |post|
          post.update_attribute(:issue_id, nil)
        end
        # Delete the current issue
        self.current_issue.reload
        self.current_issue.destroy
        @current_issue = nil
      end
      # Send any post left over
      self.posts.in_issue(nil).each do |post|
        post.send_immediatelly!
      end
    end
  end
end

class Address
  include ActiveModel::Validations
  include GeoKit::Geocoders

  # == Constants ============================================================
  
  REGISTRATION_STEPS = 3
  
  # == Attributes =====================================================
  
  # == Attribute ==========================================================

  attr_accessor :address, :city, :state, :current_step
  
  # == Validations ==========================================================

  validates :address, :city, :state,
    :presence => {:message => 'Please enter your address'}
    
  # == Instance Methods =====================================================

  def initialize(params = {})
    if params
      @address = params[:address]
      @city = params[:city]
      @state = params[:state]
    end
  end
  
  def to_key; end
  
  def full
    [self.address, self.city, self.state].join(', ')
  end
  
  def location
    @location ||= MultiGeocoder.geocode(self.full)
  end
  
  def closest_regions
    point = Point.new()
    point.set_x_y(self.location.lat, self.location.lng)
    Area.closest_from(point, 400)
  end
  
  
  def current_step
    @current_step || 1
  end
  
  def first_step?
    self.current_step == 1
  end
  
  def last_step?
    self.current_step == REGISTRATION_STEPS
  end
  
  def next_step
    self.current_step = self.current_step >= REGISTRATION_STEPS ? 1 : self.current_step + 1
  end
  
  def prev_step
    self.current_step = self.current_step <= 1 ? REGISTRATION_STEPS : self.current_step - 1
  end
  
end

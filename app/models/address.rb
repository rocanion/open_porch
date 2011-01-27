class Address
  include ActiveModel::Validations
  include GeoKit::Geocoders

  # == Constants ============================================================
  
  # == Attributes =====================================================
  
  # == Attribute ==========================================================

  attr_accessor :address, :city, :state, :area_id
  attr_accessor :location, :lat, :lng
  
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
  
  def closest_regions
    location = self.geolocate
    Rails.logger.info location.to_yaml
    if location.all.length > 1 || location.street_address.nil?
      []
    else
      point = Point.new()
      point.set_x_y(self.lat, self.lng)
      Area.closest_from(point, 400)
    end
  end
  
protected
  
  def geolocate
    @location ||= begin
      loc = Geokit::Geocoders::GoogleGeocoder.geocode(self.full)
      self.lat = loc.lat
      self.lng = loc.lng
      loc
    end
  end
  
end

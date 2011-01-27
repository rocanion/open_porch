require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  include GeoKit::Geocoders

  def test_index
    get :index
    assert_response :success
    assert_template 'index'
  end
  
  def test_new
    get :new
    assert_response :success
    assert_template 'new'
  end
  
  def test_create
    oakledge = Area.create_dummy(
      :name => 'Oakledge',
      :border => Polygon.from_coordinates([[
        [44.450713, -73.227265],
        [44.456838, -73.225943],
        [44.455921, -73.218375],
        [44.449365, -73.220694],
        [44.450713, -73.227265]
      ]])
    )
    Geokit::Geocoders::GoogleGeocoder.expects(:geocode).returns(success_geocode(44.4533518, -73.2219273))
    
    post :create, :address => {:address=>"123 Fake St", :city=>"Burlington", :state=>"Vermont"}
    assert assigns(:areas).empty?
    assert_equal oakledge, assigns(:selected_area)
    assert_response :success
    assert_template 'create'
  end
  
  def test_create_with_invalid_address
    Address.any_instance.stubs(:closest_regions).returns([])
    post :create, :address => {:address=>"123 Fake St"}
    assert_redirected_to root_path
    assert !assigns(:address).valid?
  end
  
  def test_create_with_no_regions
    Address.any_instance.stubs(:closest_regions).returns([])
    post :create, :address => {:address=>"123 Fake St", :city=>"Burlington", :state=>"Vermont"}
    assert_equal flash.now[:alert], "Sorry, we couldn't find any neighbourhoods close to you!"
    assert_redirected_to root_path
  end

protected
  def success_geocode(lat, lng)
    @success = Geokit::GeoLoc.new({
      :street_address=>"some address", 
      :city=>"SAN FRANCISCO", 
      :state=>"CA", 
      :country_code=>"US", 
      :lat=>lat, 
      :lng=>lng})
    @success.success = true
    @success
  end
end

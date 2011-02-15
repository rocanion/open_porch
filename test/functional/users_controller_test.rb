require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @area = Area.create_dummy(
      :name => 'Oakledge',
      :border => Polygon.from_coordinates([[
        [44.450713, -73.227265],
        [44.456838, -73.225943],
        [44.455921, -73.218375],
        [44.449365, -73.220694],
        [44.450713, -73.227265]
      ]])
    )
  end
  
  def test_new_with_no_address
    get :new
    assert_redirected_to root_path
  end
  
  def test_new
    get :new, :user => {
      :address=>"123 Fake St", 
      :city=>"Burlington", 
      :state=>"Vermont", 
      :memberships_attributes=>{"0"=>{:area_id => @area.id}}
    }
    assert_response :success
    assert_template 'new'
    assert_equal assigns(:area), @area
  end
  
  def test_create
    assert_difference ['User.count', 'Membership.count'] do
      assert_emails 1 do
        post :create, :user => {
          :email => 'user@example.com',
          :password => 'tester',
          :password_confirmation => 'tester',
          :address=>"123 Fake St", 
          :city=>"Burlington", 
          :state=>"Vermont",
          :first_name => 'John',
          :last_name => 'Tester', 
          :memberships_attributes=>{"0"=>{:area_id => @area.id}}
        }
        assert_redirected_to root_path
        assert_equal 'Thank you, please check your email to complete the registration.', flash[:notice]
        assert !@controller.logged_in?
        assert_not_nil assigns(:user).email_verification_key
        assert !assigns(:user).is_verified?
      end
    end
    response = ActionMailer::Base.deliveries.last
    assert_equal 2, response.parts.length
    response.parts.each do |part|
      assert_match assigns(:user).email_verification_key, part.body.to_s
    end
    assert_equal assigns(:user).email, response.to[0]
    
  end
  
  def test_create_fails
    assert_no_difference ['User.count', 'Membership.count'] do
      post :create, :user => {}
      assert_redirected_to root_path
    end
  end
  
  def test_email_verification
    user = a User
    assert_created user
    assert !user.is_verified?

    area = an Area
    assert_created area

    user.areas << area
    assert_equal area, user.areas.first
    
    user.set_email_verification_key
    user.save!
    assert !user.is_verified?
    
    get :verify_email, :email_verification_key => user.email_verification_key
    assert_equal 'Your email address has been verified. You can now login', flash[:notice]
    assert !@controller.logged_in?
    assert_redirected_to login_path
    user.reload
    assert user.is_verified?
  end
  
  def test_failed_email_verification
    user = a User
    assert_created user
    assert !user.is_verified?

    area = an Area
    assert_created area

    user.areas << area
    assert_equal area, user.areas.first
    
    user.set_email_verification_key
    user.save!
    assert !user.is_verified?
    
    get :verify_email, :email_verification_key => 'bogus'
    assert_equal 'We were not able to verify your account. Please contact us for assistance.', flash[:alert]
    assert !@controller.logged_in?
    user.reload
    assert !user.is_verified?
    assert_redirected_to root_path
  end
  
  def test_resend_email_verification
    user = a User
    assert_created user
    user.set_email_verification_key
    user.save!
    assert !user.is_verified?
    
    assert_emails 1 do
      get :resend_email_verification, :email_verification_key => user.email_verification_key
      assert_redirected_to login_path
      response = ActionMailer::Base.deliveries.last
      assert_equal 2, response.parts.length
      response.parts.each do |part|
        assert_match assigns(:user).email_verification_key, part.body.to_s
      end
      assert_equal assigns(:user).email, response.to[0]
    end
  end
end

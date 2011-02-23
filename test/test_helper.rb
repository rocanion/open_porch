ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures = false
  include ActionMailer::TestHelper
  
  def data_path(name)
    File.expand_path(File.join('test', 'data', name), Rails.root)
  end

  def assert_created(model)
    assert model
    assert_equal [ ], model.errors.full_messages
    assert model.valid?
    assert !model.new_record?
  end
  
  def assert_not_created(model)
    assert model
    assert model.new_record?
  end
  
  def assert_errors_on(model, *attrs)
    found_attrs = [ ]
    
    model.errors.each do |attr, error|
      found_attrs << attr
    end
    
    assert_equal attrs.flatten.collect(&:to_s).sort, found_attrs.uniq.collect(&:to_s).sort
  end
  
  def assert_mapping(map, &block)
    result_map = map.inject({ }) do |h, (k,v)|
      h[k] = yield(k)
      h
    end
    
    differences = result_map.inject([ ]) do |a, (k,v)|
      if (v != map[k])
        a << k
      end
      a
    end
    assert_equal map, result_map, "Difference: #{map.slice(*differences).inspect} vs #{result_map.slice(*differences).inspect}"
  end
  
  def login_as(obj)
    case obj
    when String
      user = a User
      user.update_attribute(:role, obj)
    when Symbol
      user = a User
      user.update_attribute(:role, obj.to_s)
    when User
      user = obj
    else
      raise "Please specifuy either a User or a role: #{obj.class.to_s}"
    end

    session[:user_id] = user.id
    token = Wristband::Support.encrypt_with_salt(user.id.to_s, Time.now.to_f.to_s)
    cookies[:login_token] = {
      :value => token,
      :expires => 2.weeks.from_now.utc
    }
    
    user
  end
  
  def assert_exception_raised(exception_class = nil, error_message = nil, &block)
    exception_raised = nil
    yield
  rescue => exception_raised
  ensure
    if exception_raised
      if exception_class
        assert_equal exception_class, exception_raised.class, exception_raised.to_s
      else
        assert true
      end
      assert_equal error_message, exception_raised.to_s if error_message
    else
      flunk 'Exception was not raised'
    end
  end

end

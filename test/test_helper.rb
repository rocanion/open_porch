ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures = false
  
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
end

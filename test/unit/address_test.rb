require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  
  def test_create_defaults
    address = Address.new(
      :address => '123 Fake St',
      :city => 'Burlington',
      :state => 'Vermont'
    )
    assert address.valid?
    assert_equal address.address, '123 Fake St'
    assert_equal address.city, 'Burlington'
    assert_equal address.state, 'Vermont'
  end
  
  def test_create_requirements
    address = Address.new
    assert !address.valid?
    assert_errors_on address, :address, :city, :state
    assert address.errors[:address].include?("Please enter your address")
    assert address.errors[:city].include?("Please enter your address")
    assert address.errors[:state].include?("Please enter your address")
  end
end
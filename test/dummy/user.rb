TestDummy.declare(User) do
  dummy :email do
    Faker::Internet.email
  end

  dummy :password do
    'password'
  end

  dummy :address do
    Faker::Address.street_address
  end

  dummy :city do
    Faker::Address.city
  end

  dummy :state do
    Faker::Address.us_state
  end
end

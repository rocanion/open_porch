TestDummy.declare(User) do
  dummy :email do
    Faker::Internet.email
  end
end

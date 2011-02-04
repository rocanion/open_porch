TestDummy.declare(Area) do
  dummy :name do
    Faker::Address.city
  end
end

TestDummy.declare(UserActivity) do
  
  dummy :name do
    Faker::Name.name
  end
  
  dummy :url do
    Faker::Internet.domain_name
  end
  
end

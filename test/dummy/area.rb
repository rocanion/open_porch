TestDummy.declare(Area) do
  dummy :name do
    Faker::Address.city
  end
  
  dummy :slug do
    Faker::Internet.domain_word
  end
end

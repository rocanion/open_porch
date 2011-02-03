TestDummy.declare(Issue) do
  dummy :area
  
  dummy :subject do
    Faker::Lorem.sentence
  end
end

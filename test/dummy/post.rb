TestDummy.declare(Post) do
  dummy :user
  dummy :area
  
  dummy :title do
    Faker::Lorem.sentence
    
  end
  
  dummy :content do
    Faker::Lorem.paragraph
  end
end
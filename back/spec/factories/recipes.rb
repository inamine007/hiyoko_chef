FactoryBot.define do

  factory :recipe do
    association :user
    name { 'recipe' }
    description { 'hoge' }
    cost { 100 }
    time { 10 }
    serve { 1 }
    status { 'published' }
  end
end
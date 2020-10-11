FactoryBot.define do

  sequence :user_email do |i|
    "test#{i}@example.com"
  end

  sequence :user_name do |i|
    "test#{i}"
  end

  factory :user do
    name { generate :user_name }
    email { generate :user_email }
    password { 'password' }
    introduction { 'hoge' }
  end
end
FactoryBot.define do

  factory :message do
    association :user
    association :room
    content { 'message' }
  end
end
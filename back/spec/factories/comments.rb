FactoryBot.define do

  factory :comment do
    association :user
    association :recipe
    content { 'comment' }
  end
end
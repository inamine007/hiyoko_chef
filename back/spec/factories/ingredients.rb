FactoryBot.define do

  factory :ingredient do
    association :user
    name { 'ingredient' }
    trader { 'trader' }
    unit { 'Kg' }
    unit_used { 'g' }
    cost { 100 }
    budomari { 1 }
    converted_number { 0.001 }
    cost_used { 0.1 }
  end
end
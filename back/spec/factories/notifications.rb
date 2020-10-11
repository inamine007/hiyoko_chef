FactoryBot.define do

  factory :notification do
    association :room
    association :message
    association :visited
    association :visitor
    visitor_id { visitor.id }
    visited_id { visited.id }
    recipe_id { 'null' }
    comment_id { 'null' }
    message_id { 'null' }
    room_id { 'null' }
    action { 'null' }
    checked { 'false' }
  end
end
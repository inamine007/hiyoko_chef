class RelationshipSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :user
  belongs_to :follow, class_name: 'User'
end

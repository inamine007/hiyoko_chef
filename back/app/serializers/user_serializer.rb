class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :introduction, :image, :uid


  # has_many :recipes, dependent: :destroy
  # has_many :favorites, dependent: :destroy
  # has_many :ingredients, dependent: :destroy
  # has_many :messages, dependent: :destroy
  # has_many :comments, dependent: :destroy
  # has_many :entries
  # has_many :rooms, through: :entries
  # has_many :group_users
  # has_many :groups, through: :group_users
  # has_many :relationships
  # has_many :followings, through: :relationships, source: :follow
  # has_many :reverse_of_relationships, class_name: :'Relationship', foreign_key: 'follow_id'
  # has_many :followers, through: :reverse_of_relationships, source: :user
  # has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  # has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  def image
    url_for(object.image) if object.image.attached?
  end

  def uid
    object.id
  end
end

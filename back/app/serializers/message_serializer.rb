class MessageSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :content, :name, :uid, :image

  def name
    object.user.name
  end

  def uid
    object.user.id
  end

  def image
    url_for(object.user.image) if object.user.image.attached?
  end
end

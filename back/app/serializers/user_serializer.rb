class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :introduction, :image, :uid

  def image
    url_for(object.image) if object.image.attached?
  end

  def uid
    object.id
  end
end

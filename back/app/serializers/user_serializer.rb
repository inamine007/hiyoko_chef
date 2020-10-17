class UserSerializer < ActiveModel::Serializer
  # include Rails.application.routes.url_helpers
  include CommonModule
  attributes :id, :name, :introduction, :image, :uid

  # def image
  #   url_for(object.image) if object.image.attached?
  # end

  def image
    encode_base64(object.image) if object.image.attached?
  end

  def uid
    object.id
  end
end

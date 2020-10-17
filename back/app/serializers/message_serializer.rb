class MessageSerializer < ActiveModel::Serializer
  # include Rails.application.routes.url_helpers
  include CommonModule
  attributes :id, :content, :name, :uid, :image, :created, :updated

  def name
    object.user.name
  end

  def uid
    object.user.id
  end

  # def image
  #   url_for(object.user.image) if object.user.image.attached?
  # end

  def image
    encode_base64(object.user.image) if object.user.image.attached?
  end

  def created
    object.created_at.strftime("%Y-%m-%d %H:%M")
  end

  def updated
    object.updated_at.strftime("%Y-%m-%d %H:%M")
  end
end

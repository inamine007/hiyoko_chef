class RecipeSerializer < ActiveModel::Serializer
  # include Rails.application.routes.url_helpers
  include CommonModule
  attributes :id, :rid, :name, :description, :cost, :time, :serve, :status, :category, :group_id, :image, :uname, :uimage, :favorites, :comments,
  :created, :updated

  # def image
  #   url_for(object.image) if object.image.attached?
  # end

  def image
    encode_base64(object.image) if object.image.attached?
  end

  def uname
    object.user.name
  end

  # def uimage
  #   url_for(object.user.image) if object.user.image.attached?
  # end

  def uimage
    encode_base64(object.user.image) if object.user.image.attached?
  end

  def rid
    object.id
  end

  def category
    object.categories.first
  end

  def created
    object.created_at.strftime("%Y-%m-%d %H:%M")
  end

  def updated
    object.updated_at.strftime("%Y-%m-%d %H:%M")
  end
end

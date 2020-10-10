class RecipeSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :rid, :name, :description, :cost, :time, :serve, :status, :group_id, :image, :uname, :uimage, :favorites, :comments,
  :created_at, :updated_at

  def image
    url_for(object.image) if object.image.attached?
  end

  def uname
    object.user.name
  end

  def uimage
    url_for(object.user.image) if object.user.image.attached?
  end

  def rid
    object.id
  end

  def created_at
    object.created_at.strftime("%Y-%m-%d %H:%M")
  end

  def updated_at
    object.updated_at.strftime("%Y-%m-%d %H:%M")
  end
end

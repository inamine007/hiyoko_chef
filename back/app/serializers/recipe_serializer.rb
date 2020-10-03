class RecipeSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :rid, :name, :description, :cost, :time, :serve, :status, :group_id, :image, :uname, :uimage, :favorites, :comments

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
end

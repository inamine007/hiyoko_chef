class CommentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :content, :user, :uimage, :cid

  def uimage
    url_for(object.user.image) if object.user.image.attached?
  end

  def cid
    object.id
  end
end

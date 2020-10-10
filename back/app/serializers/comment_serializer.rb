class CommentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :content, :user, :uimage, :cid, :created, :updated

  def uimage
    url_for(object.user.image) if object.user.image.attached?
  end

  def cid
    object.id
  end

  def created
    object.created_at.strftime("%Y-%m-%d %H:%M")
  end

  def updated
    object.updated_at.strftime("%Y-%m-%d %H:%M")
  end
end

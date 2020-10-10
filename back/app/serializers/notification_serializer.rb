class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :visitor_id, :visited_id, :message_id, :room_id, :checked, :name, :created, :updated

  def name
    Room.find(object.room_id).name if object.room_id.present?
  end

  def created
    object.created_at.strftime("%Y-%m-%d %H:%M")
  end

  def updated
    object.updated_at.strftime("%Y-%m-%d %H:%M")
  end
end

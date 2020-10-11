class NotificationsController < ApplicationController
  before_action :set_notifications

  def index
    render json: @notifications, each_serializer: NotificationSerializer
  end

  def checked
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
    render json: @notifications, each_serializer: NotificationSerializer
  end

  def destroy_all
    @notifications.destroy_all
    render json: { status: 'SUCCESS', message: 'Deleted the recipe', data: @notifications }
  end

  private

  def set_notifications
    @notifications = current_user.passive_notifications
  end
end

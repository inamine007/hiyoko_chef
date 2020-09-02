class NotificationsController < ApplicationController
    def index
        @notifications = current_user.passive_notifications.all
        @notifications.where(checked: false).each do |notification|
          notification.update_attributes(checked: true)
        end
        render json: { status: 'SUCCESS', data: @notifications }
    end
end

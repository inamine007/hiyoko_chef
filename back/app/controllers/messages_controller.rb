class MessagesController < ApplicationController
    before_action :set_room
    def create
        message = @room.messages.build(message_params)
        message.user_id = current_user.id
        if message.save
            @room.create_notification_message!(current_user, message.id)
            render json: { status: 'SUCCESS', data: message }
        else
            render json: { status: 'ERROR', data: message.errors.full_messages }
        end
    end

    def destroy
        message = @room.messages.find_by(id: message_params[:id])
        message.destroy
        render json: { status: 'SUCCESS', message: 'Deleted the message', data: message }
    end

    private

    def set_room
        @room = Room.find(params[:room_id])
    end

    def message_params
        params.require(:message).permit(:id, :content)
    end
end

class RoomsController < ApplicationController

    def index
        rooms = current_user.rooms.all
        render json: { status: 'SUCCESS', data: rooms }
    end

    def show
        room = Room.find(params[:id])
        users = room.users.all
        render json: { status: 'SUCCESS', data: room, data_user: users }
    end

    def create
        room = Room.new(room_params)
        user = User.find(params[:user_id])
        room.user_id = user.id
        room.users.push(current_user, user)
        if room.save
          render json: { status: 'SUCCESS', data: room }
        else
          render json: { status: 'ERROR', data: room.errors.full_messages }
        end
      end
    
      def destroy
        @rooms.destroy
        render json: { status: 'SUCCESS', message: 'Deleted the room', data: @rooms }
      end

      private

      def room_params
        params.require(:room).permit(:name)
      end
end

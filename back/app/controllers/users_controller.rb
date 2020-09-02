class UsersController < ApplicationController
    def index
        users = User.all
        render json: { status: 'SUCCESS', data: users }
    end

    def show
        user = User.find(params[:id])
        render json: { status: 'SUCCESS', data: user }
    end

    def whoami
        render json: { status: 'SUCCESS', data: current_user }
    end
end

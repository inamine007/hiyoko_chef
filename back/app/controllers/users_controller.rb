class UsersController < ApplicationController
  before_action :set_user, only: [:followings, :followers]

  def index
    users = User.all
    render json: { status: 'SUCCESS', data: users }
  end

  def show
    user = User.find(params[:id])
    if user.image.present?
      img = user.image
      user = user.as_json
      user['encode_image'] = encode_base64(img)
    end
    render json: { status: 'SUCCESS', data: user }
  end

  def whoami
    user = current_user.as_json
    if current_user.image.present?
      img = current_user.image
      user['encode_image'] = encode_base64(img)
    end
    render json: { status: 'SUCCESS', data: user }
  end

  def followings
    followings = @user.followings.all
    render json: followings, each_serializer: UserSerializer
    # render json: { status: 'SUCCESS', data_followings: followings, data_followers: followers }
  end

  def followers
    followers = @user.followers.all
    render json: followers, each_serializer: UserSerializer
  end

  private

  def encode_base64(image_file)
    image = Base64.encode64(image_file.download)
    blob = ActiveStorage::Blob.find(image_file[:id])
    "data:#{blob[:content_type]};base64,#{image}"
  end

  def set_user
    @user = User.find(params[:id])
  end

end

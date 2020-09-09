class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def create
    user = User.new user_params

    if user.save
      user.image.attach(sign_up_params[:image])
      render json: user
    else
      render json: user.errors
    end
  end
  
  private

  # def attach_main_image(user)
  #   user.image.attach(sign_up_params[:image])
  # end

  def sign_up_params
    params.require(:user).permit(:name, :email, :signed_blob_id, :password, :image, :password_confirmation, :introduction)
  end

  def user_params
    {
      name: sign_up_params[:name],
      email: sign_up_params[:email],
      password: sign_up_params[:password],
      password_confirmation: sign_up_params[:password_confirmation],
      introduction: sign_up_params[:introduction],
      # image: sign_up_params[:image]
    }
  end
 
  def account_update_params
    params.permit(:name, :email)
  end
end

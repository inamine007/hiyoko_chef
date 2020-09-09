class UsersController < ApplicationController
    def index
        users = User.all
        render json: { status: 'SUCCESS', data: users }
    end

    def show
        user = User.find(params[:id])
        img = user.image
        if img.present?
            image_url = encode_base64(img)
        end
        render json: { status: 'SUCCESS', data: user, data_image: image_url }
    end

    def whoami
        render json: { status: 'SUCCESS', data: current_user }
    end

    private

    def encode_base64(image_file)
        image = Base64.encode64(image_file.download) # 画像ファイルをActive Storageでダウンロードし、エンコードする
        blob = ActiveStorage::Blob.find(image_file[:id]) # Blobを作成
        "data:#{blob[:content_type]};base64,#{image}" # Vue側でそのまま画像として読み込み出来るBase64文字列にして返す
    end
end

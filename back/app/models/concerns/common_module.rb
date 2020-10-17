module CommonModule
  extend ActiveSupport::Concern

  def encode_base64(image_file)
    image = Base64.encode64(image_file.download)
    blob = ActiveStorage::Blob.find(image_file[:id])
    "data:#{blob[:content_type]};base64,#{image}"
  end
end
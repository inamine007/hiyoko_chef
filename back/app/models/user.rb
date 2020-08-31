# frozen_string_literal: true

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :recipes, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  has_one_attached :image
end

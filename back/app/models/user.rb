# frozen_string_literal: true

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :recipes, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :comments
  # has_one_attached :image

  # validates :introduction, length: { maximum: 300 }
end

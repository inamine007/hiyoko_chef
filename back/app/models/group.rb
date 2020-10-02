class Group < ApplicationRecord
  has_many :recipes, dependent: :destroy
  has_many :group_users
  has_many :users, through: :group_users
  has_one_attached :image

  validates :name, presence: true, length: { maximum: 20 }
  validates :introduction, length: { maximum: 140 }
  validates :password, presence: true, length: { is: 4 }
end

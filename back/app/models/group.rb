class Group < ApplicationRecord
  has_many :recipes, dependent: :destroy
  has_many :group_users
  has_many :users, through: :group_users

  validates :name, presence: true, length: { maximum: 20 }
  validates :introduction, length: { maximum: 140 }
  validates :password, presence: true, length: { is: 4 }
end

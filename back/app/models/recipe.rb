class Recipe < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy

    validates :name, presence: true
    has_many_attached :images
end

class Group < ApplicationRecord
    has_one_attached :image
    
    validates :name, presence: true
    validates :password, presence: true, length: { is: 4 }
end

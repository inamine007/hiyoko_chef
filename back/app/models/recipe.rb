class Recipe < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :notifications, dependent: :destroy
    has_many :ingredient_recipes
    has_many :ingredients, through: :ingredient_recipes
    has_many :recipe_categories
    has_many :categories, through: :recipe_categories
    accepts_nested_attributes_for :ingredient_recipes, allow_destroy: true, update_only: true
    validates :name, presence: true
    validate :validates_images

    has_many_attached :images

    def calculate_recipe_cost
        ingredient_recipes.each(&:calculate_cost_used)
        self.cost = ingredient_recipes.map(&:cost_used).sum
    end

    def create_notification_like!(current_user)
        temp = Notification.where(["visitor_id = ? and visited_id = ? and recipe_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
        if temp.blank?
            notification = current_user.active_notifications.new(
            recipe_id: id,
            visited_id: user_id,
            action: 'like'
            )
            if notification.visitor_id == notification.visited_id
                notification.checked = true
            end
            notification.save if notification.valid?
        end
    end

    def create_notification_comment!(current_user, comment_id)
        temp_ids = Comment.select(:user_id).where(recipe_id: id).where.not(user_id: current_user.id).distinct
        temp_ids.each do |temp_id|
          save_notification_comment!(current_user, comment_id, temp_id['user_id'])
        end
        save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
    end
    
    def save_notification_comment!(current_user, comment_id, visited_id)
        notification = current_user.active_notifications.new(
          recipe_id: id,
          comment_id: comment_id,
          visited_id: visited_id,
          action: 'comment'
        )
        if notification.visitor_id == notification.visited_id
            notification.checked = true
        end
        notification.save if notification.valid?
    end

    private

    before_save do
      calculate_recipe_cost
    end

    def validates_images
      if images.attached?
        if images.count >= 9
          errors.add(:base, "選択できるファイル数は8つまでです")
        end
      end
    end
end

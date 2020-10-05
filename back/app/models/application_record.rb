class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  scope :search, ->(params) do
    where("name LIKE ?", "%#{params}%")
  end
end

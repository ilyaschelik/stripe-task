class Subscription < ApplicationRecord
  validates :subscription_id, presence: true

  scope :sorted, ->(){order(created_at: :desc)}
end

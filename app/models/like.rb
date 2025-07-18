class Like < ApplicationRecord
  belongs_to :user
  belongs_to :chronicle

  validates :user_id, uniqueness: { scope: :chronicle_id }
end

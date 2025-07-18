class Publisher < ApplicationRecord
  has_many :follows, as: :followable, dependent: :destroy
  has_many :followers, through: :follows, source: :follower
end

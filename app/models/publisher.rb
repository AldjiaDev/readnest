# app/models/publisher.rb
class Publisher < ApplicationRecord
  belongs_to :user, optional: true
  has_many :chronicles
  has_one_attached :logo
end

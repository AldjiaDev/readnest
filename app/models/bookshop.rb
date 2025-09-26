class Bookshop < ApplicationRecord
  belongs_to :user
  has_one_attached :logo

  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_name?
  end
end

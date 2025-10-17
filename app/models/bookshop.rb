class Bookshop < ApplicationRecord
  belongs_to :user
  has_one_attached :logo

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_name?
  end

  # === Logo avec fallback Cloudinary / local ===
  def logo_url
    if logo.attached?
      Rails.application.routes.url_helpers.url_for(logo)
    else
      if Rails.env.production?
        # Image par défaut sur Cloudinary (mets ton vrai lien ici)
        "https://res.cloudinary.com/readnest/image/upload/v1728637102/default_bookshop.png"
      else
        ActionController::Base.helpers.asset_path("default_avatar.png")
      end
    end
  end
end

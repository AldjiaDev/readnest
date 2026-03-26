class PagesController < ApplicationController
  def bookshops
    @bookshops = Bookshop.all
  end

  def mentions_legales; end
  def confidentialite; end
  def cgu; end
  def cookies; end

  def plan_du_site
    @chronicles       = Chronicle.order(created_at: :desc).limit(20)
    @authors          = User.where(is_author: true).order(created_at: :desc).limit(20)
    @publishing_houses = PublishingHouse.order(created_at: :desc).limit(20)
    @bookshops        = Bookshop.order(created_at: :desc).limit(20)
  end
end

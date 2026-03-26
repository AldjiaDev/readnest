class PagesController < ApplicationController
  def bookshops
    @bookshops = Bookshop.all
  end

  def mentions_legales; end
  def confidentialite; end
  def cgu; end
  def cookies; end

  def ecrire_chronique; end
  def soutenir_librairies; end
  def choisir_livre; end
  def definition_chronique; end
  def litterature_francaise; end
  def editions_independantes; end
  def communaute_lecteurs; end
  def bienfaits_lecture; end
  def glossaire; end
  def librairies_paris; end
  def librairies_lyon; end
  def librairies_marseille; end

  def plan_du_site
    @chronicles       = Chronicle.order(created_at: :desc).limit(20)
    @authors          = User.where(is_author: true).order(created_at: :desc).limit(20)
    @publishing_houses = PublishingHouse.order(created_at: :desc).limit(20)
    @bookshops        = Bookshop.order(created_at: :desc).limit(20)
  end
end

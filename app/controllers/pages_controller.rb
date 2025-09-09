class PagesController < ApplicationController
  def bookshops
    @bookshops = Bookshop.all
  end
end

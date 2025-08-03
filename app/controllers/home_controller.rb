class HomeController < ApplicationController
  def index
    @chronicles = Chronicle.order(created_at: :desc).limit(6)
    @publishing_houses = PublishingHouse.limit(6)

    @top_books = [
      { title: "1984", author: "George Orwell", image: "1984.jpg" },
      { title: "Le Petit Prince", author: "Antoine de Saint-Exupéry", image: "le_petit_prince.jpg" },
      { title: "To Kill a Mockingbird", author: "Harper Lee", image: "mockingbird.jpg" },
      { title: "L'Étranger", author: "Albert Camus", image: "etranger.jpg" },
      { title: "Les Misérables", author: "Victor Hugo", image: "les_miserables.jpg" },
      { title: "The Great Gatsby", author: "F. Scott Fitzgerald", image: "gatsby.jpg" }
    ]
  end
end

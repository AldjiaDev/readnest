SitemapGenerator::Sitemap.default_host = "https://readnest-7b25107ffb5b.herokuapp.com"

SitemapGenerator::Sitemap.create do
  # Page d’accueil
  add root_path, priority: 1.0, changefreq: 'daily'

  # Chroniques
  add chronicles_path, priority: 0.7, changefreq: 'daily'
  Chronicle.find_each do |chronicle|
    add chronicle_path(chronicle), lastmod: chronicle.updated_at, priority: 0.8
  end

  # Profils utilisateurs
  User.find_each do |user|
    add user_path(user), priority: 0.5
  end

  # Maisons d’édition
  PublishingHouse.find_each do |house|
    add publishing_house_path(house), priority: 0.6
  end
end

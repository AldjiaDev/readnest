SitemapGenerator::Sitemap.default_host = "https://www.readnest.fr"

SitemapGenerator::Sitemap.create do
  # Page d’accueil
  add root_path, priority: 1.0, changefreq: 'daily'

  # Auteur·rice·s
  add authors_path, priority: 0.8, changefreq: 'weekly'

  # Maisons d'édition
  add publishing_houses_path, priority: 0.7, changefreq: 'weekly'

  # Chroniques
  add chronicles_path, priority: 0.8, changefreq: 'daily'
  Chronicle.find_each do |chronicle|
    add chronicle_path(chronicle), lastmod: chronicle.updated_at, priority: 0.9
  end

  # Librairies
  Bookshop.find_each do |bookshop|
    add bookshop_path(bookshop), lastmod: bookshop.updated_at, priority: 0.7
  end

  # Maisons d’édition
  PublishingHouse.find_each do |house|
    add publishing_house_path(house), lastmod: house.updated_at, priority: 0.7
  end

  # Profils utilisateurs (si publics)
  User.find_each do |user|
    add user_path(user), lastmod: user.updated_at, priority: 0.4
  end

  # Page "À propos"
  add about_path, priority: 0.5, changefreq: 'monthly'

  # Pages éditoriales SEO
  add ecrire_chronique_path,       priority: 0.7, changefreq: 'monthly'
  add soutenir_librairies_path,    priority: 0.7, changefreq: 'monthly'
  add choisir_livre_path,          priority: 0.7, changefreq: 'monthly'
  add definition_chronique_path,   priority: 0.7, changefreq: 'monthly'
  add litterature_francaise_path,  priority: 0.7, changefreq: 'monthly'
  add editions_independantes_path, priority: 0.7, changefreq: 'monthly'
  add communaute_lecteurs_path,    priority: 0.6, changefreq: 'monthly'
  add bienfaits_lecture_path,      priority: 0.7, changefreq: 'monthly'
  add glossaire_path,              priority: 0.7, changefreq: 'monthly'
  add librairies_paris_path,       priority: 0.8, changefreq: 'monthly'
  add librairies_lyon_path,        priority: 0.8, changefreq: 'monthly'
  add librairies_marseille_path,   priority: 0.8, changefreq: 'monthly'

  # Recherche
  add search_path, priority: 0.3, changefreq: 'weekly'
end

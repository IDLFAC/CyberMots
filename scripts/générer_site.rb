# frozen_string_literal: true

# Dépendances natives
require 'erb'
require 'json'
require 'yaml'
require 'fileutils'
# Dépendances tierces
require 'commonmarker'
# Dépendances locales
require_relative 'config'

# Génère les méta-données des mots
def génère_json
  données = []

  Dir.glob('mots/*.md').each do |mot|
    données << YAML.load_file(mot)
  end

  données
end

# Génère la page HTML de l'index et autres pages racines
def génère_pages_racines(métadonnées)
  mots_données = métadonnées
  pages_racines = %w[index à-propos]
  pages_racines.each do |page|
    page_rhtml = File.read("vues/#{page}.rhtml")
    page_erb = ERB.new(page_rhtml)
    File.write("site/#{page}.html", page_erb.result(binding))
  end
end

# Convertit un fichier markdown chaîne de caractères HTML
def md→html_file(src)
  md→html(File.read(src))
end

# Convertit une chaîne de caractère markdown chaîne de caractères HTML
def md→html(src)
  Commonmarker.to_html(src, options: {
                         parse: { smart: false },
                         render: { hardbreaks: false, unsafe: true },
                         extension: { front_matter_delimiter: '---', table: true }
                       })
end

# Génère une page dédiée pour chaque mot
def génère_pages_mots(métadonnées)
  Dir.glob('mots/*.md').each do |mot|
    mot_ndf = File.basename(mot, '.md') # nom de fichier sans extension
    mot_meta = métadonnées.find { |x| x['chemin'] == mot_ndf } # métadonnées du mot
    html = md→html_file(mot)
    page_rhtml = File.read('vues/page_mot.rhtml')
    page_erb = ERB.new(page_rhtml)
    File.write("site/#{mot_ndf}.html", page_erb.result(binding))
  end
end

def abbr(abbrev)
  terme = abbrev.dup
  dic = JSON.load_file('abréviation.json')
  dic.each do |c, v|
    terme.gsub!(c, v)
  end
  terme
end

mots_données = génère_json # aussi accessible dans les modèles
# Génère le fichier de données JSON
File.write('mots.json', mots_données.to_json)
# Génère la page d’accueil et autres pages racines
génère_pages_racines(mots_données)
# Génère la page dédiée à chaque mot
génère_pages_mots(mots_données)
# Copie les images dans le dossier destination
FileUtils.cp_r('images/', 'site/', remove_destination: true)

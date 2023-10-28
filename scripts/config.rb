# frozen_string_literal: true

# Espace de nom pour CyberMots
module CyberMots
  # configuration pour la génération du site
  module Config
    def self.base
      ENV['CYBERMOTS_BASE'] || 'https://idlfac.github.io/CyberMots/'
    end
  end
end

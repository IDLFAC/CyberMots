## Développement

### Installation des dépendances

```bash
bundle install
```

### Construction / Génération du site web

```bash
bundle exec ruby scripts/générer_site.rb
```

### Parcours local du site

```
CYBERMOTS_BASE=http://127.0.0.1:8080 bundle exec ruby scripts/générer_site.rb
ruby -run -ehttpd site
```

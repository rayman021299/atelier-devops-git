# Atelier 1 DevOps - Git

Sylvain Bourgeois (S09)

## Strategie de branches
Trunk-based development : on travaille avec des branches courtes qui partent de main et on merge rapidement pour eviter les conflits. C'est le plus simple pour le deploiement continu.

## Nommage des branches
- feat/nom-fonctionnalite
- fix/nom-bug
- docs/nom
- chore/nom

## Regles de merge
- Pull Request obligatoire pour merger sur main (pas de push direct)
- Commits conventionnels (feat:, fix:, chore:, docs:)
- Rebase interactif pour nettoyer les commits avant la PR
- Commits signes
## Notes d'atelier

### Conflit de merge (Etape 3)
Conflit sur la variable seuil entre eat/seuil-15 (seuil = 15) et eat/seuil-25 (seuil = 25) qui ont modifie la meme ligne : resolu manuellement en retenant un arbitrage a 20.
### Incidents : Cherry-pick et Git Bisect (Etape 4)
- Cherry-pick : report du commit de hotfix de division par zero depuis feat/calculs vers release/v1.0 sans prendre le reste de la branche.
- Git Bisect : recherche par dichotomie avec git bisect run qui a permis d'isoler le commit fautif 407c567 (seuil passe en str au lieu de int). Corrige sur main.
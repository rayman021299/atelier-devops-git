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
Conflit sur la variable seuil entre feat/seuil-15 (seuil = 15) et feat/seuil-25 (seuil = 25) qui ont modifie la meme ligne : resolu manuellement en retenant un arbitrage a 20.

### Incidents : Cherry-pick et Git Bisect (Etape 4)
- Cherry-pick : report du commit de hotfix de division par zero depuis feat/calculs vers release/v1.0 sans prendre le reste de la branche.
- Git Bisect : recherche par dichotomie avec git bisect run qui a permis d'isoler le commit fautif 407c567 (seuil passe en str au lieu de int). Corrige sur main.

### CODEOWNERS et revue de PR (Etape 5)
Mise en place de .github/CODEOWNERS avec assignation des zones (*.py, README.md). Ouverture de la PR #1 sur feat/division avec description, verification du code et merge sur main.

### Protection de branche (Etape 6)
Configuration d'une regle de protection sur main (PR obligatoire, historique lineaire, pas de bypass admin). Test effectue en local : push direct refuse par GitHub (erreur GH006).

### Securite du depot (Etape 7)
- Hook local pre-commit configure : verifie les diffs et refuse la creation du commit si un motif sensible est detecte (teste avec succes).
- Signature des commits activee avec cle SSH signante et badge Verified visible sur GitHub.

### Release et SemVer (Etape 8)
- Historique verifie et respectant les Conventional Commits (feat, fix, docs, chore, test).
- Creation du tag de release annote v1.0.0 marquant la premiere version stable fonctionnelle.
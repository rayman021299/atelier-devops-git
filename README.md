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

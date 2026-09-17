# TP1 DevOps - Git avancé

Sylvain Bourgeois (S09 - CSI)
Atelier realisé seul.

## Strategie de branches
Pour cet atelier j'ai choisi le Trunk-based : comme je suis seul c'est le plus simple à gerer avec une branche main et des petites branches de travail.

### Convention de nommage
- feat/* : nouvelles fonctions
- fix/* : corrections de bugs
- docs/* : documentation

### Règles pour merger sur main
- Pas de push direct (pull request obligatoire)
- Commits conventionnels (feat:, fix:, docs:)
- Rebase interactif avant merge pour garder un historique propre
- Commits signes en SSH

## Notes sur l'atelier
- Rebase interactif : test sur la branche feat/health-check en nettoyant les commits avec squash/fixup et reword pour la typo.
- Conflit de merge : provoquer sur app.py entre feat/seuil-15 et feat/seuil-25 sur la variable seuil. Résolue à la main en mettant seuil = 20 et supprimer les marqueurs de conflit.
- Cherry-pick : recupérer le commit de fix de division par zero depuis feat/calculs vers release/v1.0.
- Git bisect : utiliser pour trouver le commit qui avait introduit le bug sur seuil ("20" en str au lieu d'un entier).
- CODEOWNERS et PR : configurer pour assigner la revue, PR testée et mergée sur main.
- Protection de branche et tags : activer sur main (push direct bloque, erreur GH006) et règle active sur les tags v*.
- Pre-commit hook et signature : hook local qui bloque si présence de mots comme api_key ou password, et commits signés avec ma cle SSH (badge Verified).
- Release : tag v1.0.0 pose sur le dernier commit stable.
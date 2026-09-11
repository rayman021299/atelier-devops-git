# TP1 DevOps - Git avance

Sylvain Bourgeois (S09 - CSI)
Atelier realise seul.

## Strategie de branches
Pour cet atelier j'ai choisi le Trunk-based : comme je suis seul c'est le plus simple a gerer avec une branche main et des petites branches de travail.

### Convention de nommage
- feat/* : nouvelles fonctions
- fix/* : corrections de bugs
- docs/* : documentation

### Regles pour merger sur main
- Pas de push direct (pull request obligatoire)
- Commits conventionnels (feat:, fix:, docs:)
- Rebase interactif avant merge pour garder un historique propre
- Commits signes en SSH

## Notes sur l'atelier
- Rebase interactif : teste sur la branche feat/health-check en nettoyant les commits avec squash/fixup et reword pour la typo.
- Conflit de merge : provoque sur app.py entre feat/seuil-15 et feat/seuil-25 sur la variable seuil. Resolue a la main en mettant seuil = 20 et supprime les marqueurs de conflit.
- Cherry-pick : recupere le commit de fix de division par zero depuis feat/calculs vers release/v1.0.
- Git bisect : utilise pour trouver le commit qui avait introduit le bug sur seuil ("20" en str au lieu d'un entier).
- CODEOWNERS et PR : configure pour assigner la revue, PR testee et mergee sur main.
- Protection de branche et tags : active sur main (push direct bloque, erreur GH006) et regle active sur les tags v*.
- Pre-commit hook et signature : hook local qui bloque si presence de mots comme api_key ou password, et commits signes avec ma cle SSH (badge Verified).
- Release : tag v1.0.0 pose sur le dernier commit stable.
# TP1 DevOps - Git avance

[![CI](https://github.com/rayman021299/atelier-devops-git/actions/workflows/ci.yml/badge.svg)](https://github.com/rayman021299/atelier-devops-git/actions/workflows/ci.yml)

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

---

## TP3 - Docker

- **Dockerfile multi-stage** : passage d'une image `python:3.12` a `python:3.12-slim` pour alleger l'image finale, avec Gunicorn pour la prod a la place du serveur de dev Flask.
- **Securite** : ajout d'un `.dockerignore` (contexte passe de 22 Mo a 700 octets) et conteneur lance avec l'utilisateur non-root `stduser`.
- **Healthcheck** : test sur `/health` fait en Python (`urllib.request`) directement dans le Dockerfile vu que `curl` n'est pas installe sur l'image slim.
- **Taille de l'image (mesures sur ma machine)** :
  - Image de base naive : 1.67 Go
  - Image finale multi-stage : 207 Mo (environ 87% de gain)
- **Docker Compose** : orchestre l'application avec un service `redis:7-alpine`. Utilisation d'un volume `redis-data` pour persister le compteur `/visits` et d'une condition `service_healthy` pour attendre que Redis soit pret.
- **Publication** : image poussee sur Docker Hub (`rayman021299/app:1.0` et `rayman021299/app:latest`), testee avec suppression locale et `docker pull`.
  - Lien : https://hub.docker.com/r/rayman021299/app

### Commandes :
- Build : `docker build -t app:1.0 .`
- Lancer la stack : `docker compose up -d`
- Verifier l'etat : `docker compose ps`
- Tester : `curl http://localhost:5000/visits`
- Arreter : `docker compose down`

---

## TP4 - Deploiement continu (CD)

- **Pipeline complet** : enchainement des 4 jobs `lint` -> `test` -> `build-and-push` -> `deploy` déclenche sur chaque push sur `main`.
- **Publication** : build et push automatique sur `ghcr.io` avec deux tags : le tag immuable `${{ github.sha }}` et `latest`.
- **Architecture Blue/Green** : deux services `app-blue` (port 5001) et `app-green` (port 5002) gérés avec des profiles Docker Compose et Nginx sur le port 8080 qui route vers la version active.
- **Healthcheck reel** : `/health` vérifie la connexion Redis avec `client.ping()` et renvoie 503 si Redis est coupe (test Redis éteint et allumé).
- **Script deploy.sh et rollback auto** :
  - Démarre la couleur inactive en arriere-plan.
  - Boucle d'attente sur `/health`.
  - Smoke test sur `/status` qui vérifie la couleur et le `commit_sha`.
  - Si le test echoue : rollback automatique (arret de la nouvelle couleur, l'ancienne continue de tourner sans coupure).
  - Si le test passe : bascule Nginx a chaud avec `nginx -s reload` et arret de l'ancienne version.
- **Rollback manuel** : test en situation réelle avec `git revert` (passage a la v2.0 puis retour arriere propre via la CI).

### Commandes TP4 :
- Lancer la bascule locale : `bash deploy/deploy.sh`
- Tester un rollback (faux SHA) : `COMMIT_SHA=123 EXPECTED_SHA=faux bash deploy/deploy.sh`
- Verifier la version active : `curl http://localhost:8080/status`



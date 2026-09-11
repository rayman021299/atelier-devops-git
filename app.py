"""
Application simple de démonstration pour l'atelier DevOps Git
"""

seuil = 20


def check_threshold(valeur: int) -> bool:
    """Vérifie si une valeur dépasse le seuil configuré."""
    return valeur >= seuil


def get_status() -> dict:
    """Retourne l'état de santé du service."""
    return {
        "status": "healthy",
        "threshold": seuil,
        "version": "0.1.0"
    }


def health_check() -> dict:
    """Vérification rapide de l'API."""
    return {"status": "ok", "service": "api"}


# fonction en cours de dev
def calcul_moyenne(liste):
    if not liste:
        return 0
    return sum(liste) / len(liste)


def calcul_pourcentage(val, total):
    return (val / total) * 100


if __name__ == "__main__":
    print("Application démarrée. Seuil configuré :", seuil)
    print("Statut :", get_status())
    print("Health check :", health_check())

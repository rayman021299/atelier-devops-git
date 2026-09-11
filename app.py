"""
Application simple de démonstration pour l'atelier DevOps Git
"""

seuil = 10


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


if __name__ == "__main__":
    print("Application démarrée. Seuil configuré :", seuil)
    print("Statut :", get_status())
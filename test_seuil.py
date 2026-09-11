from app import check_threshold
try:
    assert check_threshold(25) == True
    print("OK")
    exit(0)
except Exception as e:
    print("ERREUR:", e)
    exit(1)
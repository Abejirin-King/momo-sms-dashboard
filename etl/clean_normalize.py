from datetime import datetime

def clean_data(records):
    cleaned = []
    for r in records:
        r["amount"] = round(float(r["amount"]), 2)
        r["timestamp"] = datetime.fromisoformat(r["timestamp"])
        cleaned.append(r)
    return cleaned

def categorize(records):
    for r in records:
        if r["amount"] < 2000:
            r["category"] = "Airtime"
        elif r["amount"] < 5000:
            r["category"] = "Bill Payment"
        else:
            r["category"] = "Transfer"
    return records

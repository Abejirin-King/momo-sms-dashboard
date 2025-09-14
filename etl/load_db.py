import sqlite3

def load_to_db(records, db_path="data/db.sqlite3"):
    conn = sqlite3.connect(db_path)
    c = conn.cursor()
    c.execute("""
        CREATE TABLE IF NOT EXISTS transactions (
            id INTEGER PRIMARY KEY,
            sender TEXT,
            receiver TEXT,
            amount REAL,
            currency TEXT,
            timestamp TEXT,
            category TEXT
        )
    """)
    for r in records:
        c.execute("""
            INSERT OR REPLACE INTO transactions
            (id, sender, receiver, amount, currency, timestamp, category)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """, (r["id"], r["sender"], r["receiver"], r["amount"], r["currency"], str(r["timestamp"]), r["category"]))
    conn.commit()
    conn.close()

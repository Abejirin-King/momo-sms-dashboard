from fastapi import FastAPI, Depends
import mysql.connector
from mysql.connector import Error
from typing import List, Dict

app = FastAPI(title="Momo SMS Dashboard API")

def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",          
            password="King40$$",  
            database="momo_db"   
        )
        return connection
    except Error as e:
        print("Error connecting to MySQL:", e)
        return None

@app.get("/")
def root():
    return {"message": "Momo SMS Dashboard API is running íº€"}

@app.get("/health")
def health_check():
    connection = get_db_connection()
    if connection and connection.is_connected():
        connection.close()
        return {"status": "ok", "database": "connected"}
    return {"status": "error", "database": "not connected"}

@app.get("/users")
def get_users() -> List[Dict]:
    connection = get_db_connection()
    if not connection:
        return {"error": "Database connection failed"}

    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users LIMIT 10;")
    rows = cursor.fetchall()
    connection.close()
    return rows

@app.get("/transactions")
def get_transactions() -> List[Dict]:
    connection = get_db_connection()
    if not connection:
        return {"error": "Database connection failed"}

    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM transactions LIMIT 10;")
    rows = cursor.fetchall()
    connection.close()
    return rows

# MoMo SMS Dashboard

## Team Name
Group 3

## Project Description
This project is an enterprise-level fullstack application designed to process MoMo SMS data in XML format. The system will parse, clean, and categorize transactions, store them in a relational database (SQLite), and provide a frontend dashboard for analysis and visualization.  

## Team Members
- King Abejirin  
- Teta Loice  
- Arnold MUGABO
- Mwizera Gisele  

## Scrum Board
[View our Scrum Board](https://github.com/users/Abejirin-King/projects/1)  

## Project Structure
    ```bash
    .
    ├── README.md
    ├── .env.example
    ├── requirements.txt
    ├── index.html
    ├── web/
    │ ├── styles.css
    │ ├── chart_handler.js
    │ └── assets/
    ├── data/
    │ ├── raw/
    │ ├── processed/
    │ ├── db.sqlite3
    │ └── logs/
    ├── etl/
    │ ├── init.py
    │ ├── config.py
    │ ├── parse_xml.py
    │ ├── clean_normalize.py
    │ ├── categorize.py
    │ ├── load_db.py
    │ └── run.py
    ├── api/
    │ ├── init.py
    │ ├── app.py
    │ ├── db.py
    │ └── schemas.py
    ├── scripts/
    │ ├── run_etl.sh
    │ ├── export_json.sh
    │ └── serve_frontend.sh
    └── tests/
    ├── test_parse_xml.py
    ├── test_clean_normalize.py
    └── test_categorize.py

## 🏗️ System Architecture

[View Our System Architecture](https://drive.google.com/file/d/1qUXtZGYu5cMayS05mjYsiglbUd0TFMkN/view?usp=sharing)

## Setup
1. Clone this repo:  
   ```bash
   git clone https://github.com/your-team/momo-sms-dashboard.git
   cd momo-sms-dashboard

2. Copy environment variables:
   ```bash
   cp .env.example .env

3. Install dependencies:
   ```bash
   pip install -r requirements.txt

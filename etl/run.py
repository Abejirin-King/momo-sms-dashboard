import argparse
from parse_xml import parse_xml
from clean_normalize import clean_data
from categorize import categorize
from load_db import load_to_db

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--xml", required=True, help="Path to XML file")
    args = parser.parse_args()

    
    records = parse_xml(args.xml)
    
    records = clean_data(records)
    
    records = categorize(records)
  
    load_to_db(records)

    print("ETL pipeline completed successfully.")

import argparse
import os
import json

def main(xml_path, out_path):
   
    print(f"Parsing XML from {xml_path}...")
  
    print("Cleaning and normalizing data...")
    

    print("Categorizing transactions...")
   

    print("Loading to database...")
   
    print(f"Saving processed data to {out_path}...")
    os.makedirs(os.path.dirname(out_path), exist_ok=True)

    with open(out_path, "w") as f:
        json.dump({"message": "ETL pipeline placeholder"}, f, indent=4)

    print("ETL pipeline completed successfully.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="MoMo ETL Pipeline")
    parser.add_argument("--xml", required=True, help="Path to raw XML file")
    parser.add_argument("--out", required=True, help="Path to output JSON file")
    args = parser.parse_args()

    main(args.xml, args.out)

import xml.etree.ElementTree as ET

def parse_xml(xml_file):
    tree = ET.parse(xml_file)
    root = tree.getroot()
    transactions = []
    for tx in root.findall("transaction"):
        transactions.append({
            "id": tx.get("id"),
            "sender": tx.find("sender").text,
            "receiver": tx.find("receiver").text,
            "amount": float(tx.find("amount").text),
            "currency": tx.find("currency").text,
            "timestamp": tx.find("timestamp").text
        })
    return transactions

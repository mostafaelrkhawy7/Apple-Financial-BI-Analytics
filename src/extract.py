
import requests
import json
import os

from dotenv import load_dotenv
from pathlib import Path


# Load environment variables
load_dotenv()

# Apple Company CIK
CIK = "0000320193"

# SEC API Endpoint
URL = (
    f"https://data.sec.gov/api/xbrl/"
    f"companyfacts/CIK{CIK}.json"
)

# Request Headers
headers = {
    "User-Agent": os.getenv("SEC_USER_AGENT")
}


def extract_company_data():

    print("Connecting to SEC API...")

    if not headers["User-Agent"]:
        raise ValueError("SEC_USER_AGENT is missing from .env")

    response = requests.get(
        URL,
        headers=headers,
        timeout=30
    )

    response.raise_for_status()

    data = response.json()

    print("Data extracted successfully!")

    # Create raw data directory
    output_dir = Path("data/raw")
    output_dir.mkdir(parents=True, exist_ok=True)

    # Save raw JSON
    output_file = output_dir / "apple_company_facts.json"

    with open(output_file, "w", encoding="utf-8") as file:
        json.dump(data, file, indent=4)

    print(f"Raw data saved to: {output_file}")

    return data


if __name__ == "__main__":

    company_data = extract_company_data()

    print("Company:", company_data["entityName"])

    print("Available Taxonomies:",
          list(company_data["facts"].keys()))


import json
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

file_path = (
    BASE_DIR / "data" / "raw" /
    "apple_company_facts.json"
)

with open(file_path, "r", encoding="utf-8") as file:
    data = json.load(file)

facts = data["facts"]["us-gaap"]

metrics = [
    "Revenues",
    "NetIncomeLoss",
    "Assets",
    "Liabilities",
    "OperatingIncomeLoss"
]

for metric in metrics:

    print("\n" + "=" * 50)
    print(f"METRIC: {metric}")

    if metric not in facts:
        print("Metric not found")
        continue

    metric_data = facts[metric]

    for unit, records in metric_data["units"].items():

        print(f"\nUnit: {unit}")
        print(f"Total Records: {len(records)}")

        # Display last 5 records
        for record in records[-5:]:

            print({
                "start": record.get("start"),
                "end": record.get("end"),
                "value": record.get("val"),
                "form": record.get("form"),
                "filed": record.get("filed"),
                "fy": record.get("fy"),
                "fp": record.get("fp")
            })

print("\n" + "=" * 60)
print("SEARCHING FOR REVENUE CONCEPTS")
print("=" * 60)

for concept, details in facts.items():

    if "revenue" in concept.lower():

        print("\nConcept:", concept)
        print("Label:", details.get("label"))

        units = details.get("units", {})

        for unit, records in units.items():

            print("Unit:", unit)
            print("Total Records:", len(records))

            for record in records[-3:]:

                print({
                    "start": record.get("start"),
                    "end": record.get("end"),
                    "value": record.get("val"),
                    "form": record.get("form"),
                    "fy": record.get("fy"),
                    "fp": record.get("fp")
                })

# Search for total revenue concepts

revenue_candidates = [
    "RevenueFromContractWithCustomerExcludingAssessedTax",
    "SalesRevenueNet",
    "Revenues"
]

for concept in revenue_candidates:

    print("\n" + "=" * 50)
    print("Concept:", concept)

    if concept not in facts:
        print("Not available")
        continue

    details = facts[concept]

    print("Label:", details["label"])

    for unit, records in details["units"].items():

        annual_records = [
            record for record in records
            if record.get("form") == "10-K"
            and record.get("fp") == "FY"
            and record.get("start") is not None
        ]

        annual_records = sorted(
            annual_records,
            key=lambda x: x["end"]
        )

        print("Total Annual Records:", len(annual_records))

        for record in annual_records[-5:]:

            print({
                "start": record.get("start"),
                "end": record.get("end"),
                "value": record.get("val"),
                "filed": record.get("filed"),
                "fy": record.get("fy"),
                "fp": record.get("fp")
            })

concept = "SalesRevenueNet"

records = facts[concept]["units"]["USD"]

annual_records = []

for record in records:

    if record.get("form") != "10-K":
        continue

    if record.get("fp") != "FY":
        continue

    if not record.get("start"):
        continue

    from datetime import date

    start = date.fromisoformat(record["start"])
    end = date.fromisoformat(record["end"])

    duration = (end - start).days

    if 330 <= duration <= 380:

        annual_records.append({
            "start": record["start"],
            "end": record["end"],
            "value": record["val"],
            "fy": record.get("fy"),
            "filed": record.get("filed")
        })

print("\nHistorical Revenue Records")

for record in sorted(
    annual_records,
    key=lambda x: x["end"]
):

    print(record)

print("\nTotal Annual Records:", len(annual_records))

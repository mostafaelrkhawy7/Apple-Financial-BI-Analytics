
import json
import pandas as pd

from pathlib import Path


# =====================================
# 1. Project Paths
# =====================================

BASE_DIR = Path(__file__).resolve().parent.parent

RAW_FILE = BASE_DIR / "data" / "raw" / "apple_company_facts.json"

OUTPUT_DIR = BASE_DIR / "data" / "processed"

OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

OUTPUT_FILE = OUTPUT_DIR / "apple_annual_financials.csv"


# =====================================
# 2. Financial Concepts
# =====================================

REVENUE_CONCEPTS = [
    "SalesRevenueNet",
    "RevenueFromContractWithCustomerExcludingAssessedTax"
]

METRICS = {
    "Net_Income": "NetIncomeLoss",
    "Operating_Income": "OperatingIncomeLoss",
    "Total_Assets": "Assets",
    "Total_Liabilities": "Liabilities"
}


# =====================================
# 3. Load Raw JSON
# =====================================

def load_company_facts():

    with open(RAW_FILE, "r", encoding="utf-8") as file:
        data = json.load(file)

    return data["facts"]["us-gaap"]


facts = load_company_facts()


# =====================================
# 4. Extract Annual Records
# =====================================

def extract_annual_metric(concept):

    if concept not in facts:
        print(f"Warning: Concept not found: {concept}")
        return pd.DataFrame()

    units = facts[concept]["units"]

    # Apple financial concepts are expected in USD
    if "USD" not in units:
        print(f"Warning: USD unit not found for {concept}")
        return pd.DataFrame()

    records = units["USD"]

    annual_records = []

    for record in records:

        if record.get("form") != "10-K":
            continue

        if record.get("fp") != "FY":
            continue

        start = record.get("start")
        end = record.get("end")

        if not end:
            continue

        # Flow metrics: annual duration validation
        if start is not None:

            start_date = pd.to_datetime(start)
            end_date = pd.to_datetime(end)

            duration = (end_date - start_date).days

            if not 330 <= duration <= 380:
                continue

        annual_records.append({
            "start": start,
            "end": end,
            "value": record["val"],
            "filed": record.get("filed"),
            "fy": record.get("fy")
        })

    if not annual_records:
        return pd.DataFrame()

    df = pd.DataFrame(annual_records)

    # Keep the latest filing for each reporting period
    df = df.sort_values("filed")

    df = df.drop_duplicates(
        subset=["start", "end"],
        keep="last"
    )

    return df.reset_index(drop=True)


# =====================================
# 5. Extract Revenue from Multiple Concepts
# =====================================

def extract_revenue():

    revenue_dataframes = []

    for concept in REVENUE_CONCEPTS:

        print(f"Extracting Revenue from: {concept}")

        df = extract_annual_metric(concept)

        if df.empty:
            continue

        df["period_end"] = pd.to_datetime(df["end"])

        df = df[[
            "period_end",
            "value",
            "filed"
        ]].copy()

        df = df.rename(columns={
            "value": "Revenue"
        })

        # New revenue concept has higher priority
        if concept == "RevenueFromContractWithCustomerExcludingAssessedTax":
            df["priority"] = 1
        else:
            df["priority"] = 0

        df["revenue_concept"] = concept

        revenue_dataframes.append(df)

    if not revenue_dataframes:

        return pd.DataFrame(
            columns=["period_end", "Revenue"]
        )

    revenue_df = pd.concat(
        revenue_dataframes,
        ignore_index=True
    )

    # Sort by concept priority, then filing date
    revenue_df = revenue_df.sort_values(
        ["priority", "filed"],
        ascending=[False, False]
    )

    # Keep one Revenue value per reporting period
    revenue_df = revenue_df.drop_duplicates(
        subset=["period_end"],
        keep="first"
    )

    revenue_df = revenue_df[[
        "period_end",
        "Revenue"
    ]]

    return revenue_df.reset_index(drop=True)


# =====================================
# 6. Transform Financial Metrics
# =====================================

def transform_financial_metrics():

    dataframes = []

    # Extract Revenue separately
    print("\nProcessing: Revenue")

    revenue_df = extract_revenue()

    dataframes.append(revenue_df)

    # Extract remaining metrics
    for metric_name, concept in METRICS.items():

        print(f"Processing: {metric_name}")

        df = extract_annual_metric(concept)

        if df.empty:
            print(f"Warning: No records found for {metric_name}")
            continue

        df["period_end"] = pd.to_datetime(df["end"])

        df = df[[
            "period_end",
            "value"
        ]].copy()

        df = df.rename(columns={
            "value": metric_name
        })

        dataframes.append(df)

    # Merge all metrics
    final_df = dataframes[0]

    for df in dataframes[1:]:

        final_df = final_df.merge(
            df,
            on="period_end",
            how="outer"
        )

    return final_df


# =====================================
# 7. Final Cleaning
# =====================================

def clean_financial_data(df):

    df = df.copy()

    df["period_end"] = pd.to_datetime(df["period_end"])

    df = df.sort_values("period_end")

    # Apple's fiscal year label based on fiscal period end year
    df["fiscal_year"] = df["period_end"].dt.year

    final_columns = [
        "fiscal_year",
        "period_end",
        "Revenue",
        "Net_Income",
        "Operating_Income",
        "Total_Assets",
        "Total_Liabilities"
    ]

    df = df.reindex(columns=final_columns)

    df = df.reset_index(drop=True)

    return df


# =====================================
# 8. Data Quality Checks
# =====================================

def validate_data(df):

    print("\n========== DATA QUALITY CHECKS ==========")

    print("\nTotal Records:")
    print(len(df))

    print("\nMissing Values:")
    print(df.isnull().sum())

    print("\nDuplicate Periods:")
    print(df["period_end"].duplicated().sum())

    print("\nRevenue Records:")
    print(df["Revenue"].count())

    print("\nRevenue Missing Values:")
    print(df["Revenue"].isnull().sum())

    print("\n=========================================")


# =====================================
# 9. Save Processed Data
# =====================================

def save_processed_data(df):

    df.to_csv(
        OUTPUT_FILE,
        index=False
    )

    print(f"\nProcessed data saved to: {OUTPUT_FILE}")


# =====================================
# 10. Main Execution
# =====================================

def main():

    print("Starting Apple Financial Data Transformation...")

    final_df = transform_financial_metrics()

    final_df = clean_financial_data(final_df)

    validate_data(final_df)

    save_processed_data(final_df)

    print("\nTransformation Completed!")

    print("\nFinal DataFrame:")
    print(final_df.to_string(index=False))

    print("\nDataFrame Information:")
    final_df.info()


if __name__ == "__main__":
    main()

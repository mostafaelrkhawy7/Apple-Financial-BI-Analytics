
import pandas as pd
import mysql.connector

from pathlib import Path
import os
from dotenv import load_dotenv

# Load environment variables from .env
load_dotenv()

# =====================================
# 1. Project Paths
# =====================================

BASE_DIR = Path(__file__).resolve().parent.parent

CSV_FILE = BASE_DIR / "data" / "processed" / "apple_annual_financials.csv"


# =====================================
# 2. MySQL Configuration
# =====================================

DB_CONFIG = {
    "host": os.getenv("DB_HOST"),
    "port": int(os.getenv("DB_PORT", 3306)),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "database": os.getenv("DB_NAME")
}


# =====================================
# 3. Load CSV
# =====================================

def load_csv():

    if not CSV_FILE.exists():
        raise FileNotFoundError(
            f"CSV file not found: {CSV_FILE}"
        )

    df = pd.read_csv(CSV_FILE)

    df["period_end"] = pd.to_datetime(df["period_end"])

    # Convert NaN values to None for MySQL
    df = df.astype(object).where(pd.notna(df), None)

    print(f"CSV Loaded Successfully: {len(df)} records")

    return df


# =====================================
# 4. Connect to MySQL
# =====================================

def create_connection():

    connection = mysql.connector.connect(**DB_CONFIG)

    print("MySQL Connection Successful!")

    return connection


# =====================================
# 5. Create Table
# =====================================

def create_table(connection):

    cursor = connection.cursor()

    create_table_query = """
    CREATE TABLE IF NOT EXISTS annual_financials (

        fiscal_year INT PRIMARY KEY,

        period_end DATE NOT NULL UNIQUE,

        Revenue BIGINT,

        Net_Income BIGINT,

        Operating_Income BIGINT,

        Total_Assets BIGINT,

        Total_Liabilities BIGINT

    );
    """

    cursor.execute(create_table_query)

    connection.commit()

    cursor.close()

    print("Table Created Successfully!")


# =====================================
# 6. Insert Data
# =====================================

def insert_data(connection, df):

    cursor = connection.cursor()

    insert_query = """
    INSERT INTO annual_financials (
        fiscal_year,
        period_end,
        Revenue,
        Net_Income,
        Operating_Income,
        Total_Assets,
        Total_Liabilities
    )
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    ON DUPLICATE KEY UPDATE

        period_end = VALUES(period_end),
        Revenue = VALUES(Revenue),
        Net_Income = VALUES(Net_Income),
        Operating_Income = VALUES(Operating_Income),
        Total_Assets = VALUES(Total_Assets),
        Total_Liabilities = VALUES(Total_Liabilities);
    """

    records = []

    for row in df.itertuples(index=False, name=None):

        records.append((
            int(row[0]),
            row[1].date(),
            row[2],
            row[3],
            row[4],
            row[5],
            row[6]
        ))

    cursor.executemany(insert_query, records)

    connection.commit()

    print(f"Successfully Loaded: {len(records)} records")

    cursor.close()


# =====================================
# 7. Verify Loaded Data
# =====================================

def verify_data(connection):

    cursor = connection.cursor()

    cursor.execute("""
        SELECT COUNT(*)
        FROM annual_financials;
    """)

    total_records = cursor.fetchone()[0]

    print(f"\nTotal Records in MySQL: {total_records}")

    cursor.execute("""
        SELECT *
        FROM annual_financials
        ORDER BY fiscal_year;
    """)

    for row in cursor.fetchall():
        print(row)

    cursor.close()


# =====================================
# 8. Main Execution
# =====================================

def main():

    connection = None

    try:

        df = load_csv()

        connection = create_connection()

        create_table(connection)

        insert_data(connection, df)

        verify_data(connection)

        print("\nData Loading Completed Successfully!")

    except Exception as error:

        print(f"\nError: {error}")

        if connection and connection.is_connected():
            connection.rollback()

    finally:

        if connection and connection.is_connected():
            connection.close()
            print("\nMySQL Connection Closed.")


if __name__ == "__main__":
    main()

# Apple Financial Data Pipeline & Analytics

An end-to-end financial data engineering and analytics project focused
on Apple's historical financial performance. The project covers data
ingestion, ETL processing, layered data organization (Bronze, Silver,
and Gold), database connectivity, SQL analytics, and business
intelligence reporting.

## 1. Project Objective

The goal of this project is to build a structured data pipeline that
transforms raw financial data from the SEC Company Facts API into clean,
organized, and analytics-ready datasets that can support financial
analysis and reporting.

The project follows the data lifecycle:

**Source → Extract → Transform → Layered Storage → Database → SQL
Analytics → Power BI**

## 2. Data Source

-   **Source:** SEC EDGAR -- Company Facts API
-   **Company:** Apple Inc.
-   **Ticker:** AAPL
-   **Identifier (CIK):** `0000320193`
-   **Input format:** JSON

The SEC API provides company financial facts that are used as the source
for the pipeline.

## 3. Data Engineering Architecture

The project uses a three-layer data architecture:

### Bronze Layer -- Raw Data

The Bronze layer is the initial landing layer for source data.

**Purpose:** - Preserve the extracted source data. - Keep the original
data available for downstream processing. - Separate raw ingestion from
transformation.

**Project flow:** - Connect to the SEC Company Facts API. - Extract the
source response. - Store the raw data in JSON format for processing.

### Silver Layer -- Cleaned and Transformed Data

The Silver layer contains data after preparation and quality checks.

**Purpose:** - Transform semi-structured JSON data into structured
records. - Select the required financial facts. - Standardize the data
for analysis. - Handle duplicate records and missing values.

**Processing activities:** - Extract annual financial records. - Work
with relevant revenue concepts, including: - `SalesRevenueNet` -
`RevenueFromContractWithCustomerExcludingAssessedTax` - Organize records
by fiscal year. - Apply data-cleaning and validation steps. - Remove
duplicate records. - Preserve missing values rather than creating
unsupported values. - Prepare structured output for loading.

### Gold Layer -- Analytics-Ready Data

The Gold layer is the curated layer intended for analytical use.

**Purpose:** - Provide organized financial data for business analysis. -
Make key financial measures easier to query and report. - Prepare the
data for downstream SQL analysis and BI reporting.

The project's annual financial dataset includes measures such as: -
Revenue - Net Income - Operating Income - Total Assets - Total
Liabilities

> The exact table and file names for each individual layer should match
> the implementation in the project repository.

## 4. ETL Pipeline

The project implements an ETL workflow using Python.

### Extract

-   Send requests to the SEC Company Facts API.
-   Retrieve the company's financial facts in JSON format.

### Transform

-   Parse the API response.
-   Select the required financial concepts.
-   Organize the financial data by fiscal year.
-   Clean and structure the records using Python and Pandas.
-   Apply duplicate handling and data quality checks.

### Load

-   Prepare the transformed dataset for database loading.
-   Load the annual financial records into MySQL.
-   Use an Upsert approach to avoid creating duplicate records when
    loading existing fiscal-year data again.

## 5. Database Integration

The project connects the Python ETL process to a MySQL database.

  Item               Value
  ------------------ -------------------------
  Database engine    MySQL
  Database name      `apple_financials`
  Main table         `annual_financials`
  Data grain         Annual financial record
  Loading approach   Upsert

The database acts as the structured storage layer for the processed
financial data and provides a source for SQL-based analysis.

## 6. SQL Analytics Layer

SQL is used to analyze the financial data and prepare reusable
analytical outputs.

The analysis is organized into the following modules:

  Module                            Focus
  --------------------------------- ----------------------------
  `01_revenue_analysis.sql`         Revenue analysis
  `02_profitability_analysis.sql`   Profitability analysis
  `03_financial_position.sql`       Assets and liabilities
  `04_growth_analysis.sql`          Financial growth
  `05_business_insights.sql`        Business-oriented insights
  `06_create_views.sql`             Analytical SQL views

### Analytical Topics

-   Annual revenue trends.
-   Profitability performance.
-   Financial position over time.
-   Year-over-year growth.
-   Business insights derived from financial indicators.

### SQL Views

The project includes an analytical views layer intended to make query
results easier to reuse in reporting:

-   `vw_revenue_analysis`
-   `vw_profitability_analysis`
-   `vw_financial_position`
-   `vw_growth_analysis`

## 7. Power BI Reporting

Power BI is the reporting layer planned for presenting the financial
analysis through interactive dashboards.

The reporting areas include:

-   **Overview:** High-level financial KPIs and performance trends.
-   **Profitability:** Profit and profitability indicators.
-   **Financial Position:** Assets and liabilities.
-   **Growth Analysis:** Financial growth across fiscal years.

The dashboards should be described as completed only when the
corresponding Power BI report pages have been implemented and saved in
the repository.

## 8. Technology Stack

  Technology              Usage
  ----------------------- -----------------------------------------
  SEC Company Facts API   Financial data source
  Python                  Pipeline development
  Requests                API communication
  Pandas                  Data transformation and cleaning
  JSON                    Raw source-data format
  CSV                     Structured data exchange
  MySQL                   Relational database storage
  SQL                     Financial analysis and analytical views
  Power BI                Business intelligence reporting
  Git & GitHub            Version control and project hosting

## 9. Key Data Engineering Concepts Applied

-   API-based data ingestion.
-   ETL pipeline development.
-   Bronze, Silver, and Gold layered architecture.
-   Semi-structured JSON processing.
-   Data cleaning and standardization.
-   Duplicate handling.
-   Missing-value awareness.
-   Database connectivity.
-   Relational data storage.
-   Upsert-based loading.
-   SQL analytics and views.
-   Separation of data processing, storage, and reporting layers.

## 10. End-to-End Workflow

1.  Retrieve Apple's financial facts from the SEC API.
2.  Store the extracted source data in the raw ingestion layer (Bronze).
3.  Parse, clean, validate, and structure the data in the transformation
    layer (Silver).
4.  Prepare curated, analytics-ready financial records in the Gold
    layer.
5.  Load the prepared records into MySQL.
6.  Analyze financial performance using SQL.
7.  Expose reusable analytical results through SQL Views.
8.  Use the analytical outputs as the data source for Power BI
    reporting.

## 11. Repository Structure

The following is a suggested documentation structure. Keep only folders
and files that actually exist in the repository.

``` text
Apple-Financial-Data-Pipeline/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── scripts/
│   ├── extract/
│   ├── transform/
│   └── load/
│
├── sql/
│   ├── 01_revenue_analysis.sql
│   ├── 02_profitability_analysis.sql
│   ├── 03_financial_position.sql
│   ├── 04_growth_analysis.sql
│   ├── 05_business_insights.sql
│   └── 06_create_views.sql
│
├── powerbi/
│
├── README.md
├── requirements.txt
├── .env.example
└── .gitignore
```

## 12. Project Summary

This project demonstrates an end-to-end data workflow for financial
analytics. It combines API data extraction, Python-based ETL,
Bronze/Silver/Gold data layers, MySQL database integration, SQL
analysis, and a Power BI reporting layer.

It demonstrates practical experience across core Data Engineering and
Business Intelligence activities, from collecting and preparing raw data
to storing it in a relational database and making it available for
analytical reporting.

------------------------------------------------------------------------

**Important documentation note:** Update the layer descriptions, folder
structure, record counts, filenames, and Power BI status to reflect the
exact implementation in the repository. Do not publish credentials or
secret values. Use `.env.example` with placeholders and keep the real
`.env` file private.


-- =====================================================
-- Project: Apple Financial Analysis
-- Module 03: Financial Position Analysis
-- Database: apple_financials
-- Description: Analyze Apple's financial position
-- =====================================================

USE apple_financials;


-- =====================================================
-- Query 01: Annual Financial Position
-- Business Question:
-- How have Apple's Assets and Liabilities
-- changed over the years?
-- =====================================================

SELECT
    fiscal_year,
    ROUND(Total_Assets / 1000000000, 2) AS Total_Assets_Billions,
    ROUND(Total_Liabilities / 1000000000, 2) AS Total_Liabilities_Billions
FROM annual_financials
ORDER BY fiscal_year;


-- =====================================================
-- Query 02: Total Equity
-- Business Question:
-- What is Apple's total shareholders' equity?
--
-- Formula:
-- Equity = Total Assets - Total Liabilities
-- =====================================================

SELECT
    fiscal_year,
    ROUND(Total_Assets / 1000000000, 2) AS Total_Assets_Billions,
    ROUND(Total_Liabilities / 1000000000, 2) AS Total_Liabilities_Billions,
    ROUND(
        (Total_Assets - Total_Liabilities) / 1000000000,
        2
    ) AS Total_Equity_Billions
FROM annual_financials
WHERE Total_Assets IS NOT NULL
  AND Total_Liabilities IS NOT NULL
ORDER BY fiscal_year;


-- =====================================================
-- Query 03: Liabilities-to-Assets Ratio
-- Business Question:
-- What percentage of Apple's Assets is financed
-- by Liabilities?
--
-- Formula:
-- Total Liabilities / Total Assets * 100
-- =====================================================

SELECT
    fiscal_year,
    ROUND(
        Total_Liabilities / NULLIF(Total_Assets, 0) * 100,
        2
    ) AS Liabilities_to_Assets_Percentage
FROM annual_financials
WHERE Total_Assets IS NOT NULL
  AND Total_Liabilities IS NOT NULL
ORDER BY fiscal_year;


-- =====================================================
-- Query 04: Equity Ratio
-- Business Question:
-- What percentage of Apple's Assets is financed
-- by Shareholders' Equity?
--
-- Formula:
-- Total Equity / Total Assets * 100
-- =====================================================

SELECT
    fiscal_year,
    ROUND(
        (
            (Total_Assets - Total_Liabilities)
            / NULLIF(Total_Assets, 0)
        ) * 100,
        2
    ) AS Equity_Ratio_Percentage
FROM annual_financials
WHERE Total_Assets IS NOT NULL
  AND Total_Liabilities IS NOT NULL
ORDER BY fiscal_year;


-- =====================================================
-- Query 05: Assets vs Liabilities Growth
-- Business Question:
-- How quickly are Assets and Liabilities growing?
-- =====================================================

WITH Financial_Trend AS (
    SELECT
        fiscal_year,
        Total_Assets,
        Total_Liabilities,

        LAG(Total_Assets) OVER (
            ORDER BY fiscal_year
        ) AS Previous_Assets,

        LAG(Total_Liabilities) OVER (
            ORDER BY fiscal_year
        ) AS Previous_Liabilities

    FROM annual_financials
)

SELECT
    fiscal_year,

    ROUND(
        (
            (Total_Assets - Previous_Assets)
            / NULLIF(Previous_Assets, 0)
        ) * 100,
        2
    ) AS Assets_Growth_Percentage,

    ROUND(
        (
            (Total_Liabilities - Previous_Liabilities)
            / NULLIF(Previous_Liabilities, 0)
        ) * 100,
        2
    ) AS Liabilities_Growth_Percentage

FROM Financial_Trend
ORDER BY fiscal_year;


-- =====================================================
-- End of Module 03: Financial Position Analysis
-- =====================================================

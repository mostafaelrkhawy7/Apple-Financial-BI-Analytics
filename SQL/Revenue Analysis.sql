CREATE DATABASE apple_financials;


USE apple_financials;



-- =====================================================
-- Project: Apple Financial Analysis
-- Module 01: Revenue Analysis
-- Database: apple_financials
-- Description: Analyze Apple's annual revenue performance
-- =====================================================


USE apple_financials;


-- =====================================================
-- Query 01: Annual Revenue Trend
-- Business Question:
-- How has Apple's revenue changed over the years?
-- =====================================================

SELECT
    fiscal_year,
    Revenue,
    ROUND(Revenue / 1000000000, 2) AS Revenue_Billions
FROM annual_financials
ORDER BY fiscal_year;


-- =====================================================
-- Query 02: Year-over-Year (YoY) Revenue Growth
-- Business Question:
-- What is the annual revenue growth rate?
--
-- LAG(): Retrieves the previous year's revenue.
-- CTE: Organizes the intermediate result.
-- NULLIF(): Prevents division by zero.
-- =====================================================

WITH Revenue_Trend AS (
    SELECT
        fiscal_year,
        Revenue,
        LAG(Revenue) OVER (
            ORDER BY fiscal_year
        ) AS Previous_Revenue
    FROM annual_financials
)

SELECT
    fiscal_year,
    ROUND(Revenue / 1000000000, 2) AS Revenue_Billions,
    ROUND(Previous_Revenue / 1000000000, 2) AS Previous_Revenue_Billions,
    ROUND(
        (
            (Revenue - Previous_Revenue)
            / NULLIF(Previous_Revenue, 0)
        ) * 100,
        2
    ) AS Revenue_Growth_Percentage
FROM Revenue_Trend
ORDER BY fiscal_year;


-- =====================================================
-- Query 03: Highest and Lowest Revenue
-- Business Question:
-- What are the highest and lowest revenue values
-- recorded during the available period?
-- =====================================================

SELECT
    MAX(Revenue) AS Highest_Revenue,
    MIN(Revenue) AS Lowest_Revenue
FROM annual_financials;


-- =====================================================
-- Query 04: Year with Highest Revenue
-- Business Question:
-- Which fiscal year recorded the highest revenue?
-- =====================================================

SELECT
    fiscal_year,
    ROUND(Revenue / 1000000000, 2) AS Revenue_Billions
FROM annual_financials
ORDER BY Revenue DESC
LIMIT 1;


-- =====================================================
-- Query 05: Revenue Compound Annual Growth Rate
-- Business Question:
-- What was Apple's average annual compounded
-- revenue growth rate across the available period?
--
-- CAGR = Compound Annual Growth Rate
-- POW(): Calculates the required exponent.
-- =====================================================

SELECT
    MIN(fiscal_year) AS Start_Year,
    MAX(fiscal_year) AS End_Year,
    ROUND(
        (
            POW(
                MAX(Revenue) / MIN(Revenue),
                1.0 / (MAX(fiscal_year) - MIN(fiscal_year))
            ) - 1
        ) * 100,
        2
    ) AS Revenue_CAGR_Percentage
FROM annual_financials;


-- =====================================================
-- End of Module 01: Revenue Analysis
-- =====================================================

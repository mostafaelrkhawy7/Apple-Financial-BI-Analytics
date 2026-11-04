
-- =====================================================
-- Project: Apple Financial Analysis
-- Module 02: Profitability Analysis
-- Database: apple_financials
-- Description: Analyze Apple's profitability performance
-- =====================================================

USE apple_financials;


-- =====================================================
-- Query 01: Annual Profit Trend
-- Business Question:
-- How have Apple's Net Income and Operating Income
-- changed over the years?
-- =====================================================

SELECT
    fiscal_year,
    ROUND(Net_Income / 1000000000, 2) AS Net_Income_Billions,
    ROUND(Operating_Income / 1000000000, 2) AS Operating_Income_Billions
FROM annual_financials
ORDER BY fiscal_year;


-- =====================================================
-- Query 02: Net Profit Margin
-- Business Question:
-- How much net profit does Apple generate
-- from every 100 dollars of revenue?
--
-- Formula:
-- Net Profit Margin = Net Income / Revenue * 100
-- =====================================================

SELECT
    fiscal_year,
    ROUND(Revenue / 1000000000, 2) AS Revenue_Billions,
    ROUND(Net_Income / 1000000000, 2) AS Net_Income_Billions,
    ROUND(
        Net_Income / NULLIF(Revenue, 0) * 100,
        2
    ) AS Net_Profit_Margin
FROM annual_financials
ORDER BY fiscal_year;


-- =====================================================
-- Query 03: Operating Profit Margin
-- Business Question:
-- How profitable are Apple's core operations
-- relative to its revenue?
--
-- Formula:
-- Operating Profit Margin = Operating Income
--                           / Revenue * 100
-- =====================================================

SELECT
    fiscal_year,
    ROUND(Revenue / 1000000000, 2) AS Revenue_Billions,
    ROUND(Operating_Income / 1000000000, 2) AS Operating_Income_Billions,
    ROUND(
        Operating_Income / NULLIF(Revenue, 0) * 100,
        2
    ) AS Operating_Profit_Margin
FROM annual_financials
ORDER BY fiscal_year;


-- =====================================================
-- Query 04: Net vs Operating Profit Margin
-- Business Question:
-- How does Apple's overall profitability compare
-- with its operating profitability?
-- =====================================================

SELECT
    fiscal_year,
    ROUND(
        Net_Income / NULLIF(Revenue, 0) * 100,
        2
    ) AS Net_Profit_Margin,
    ROUND(
        Operating_Income / NULLIF(Revenue, 0) * 100,
        2
    ) AS Operating_Profit_Margin
FROM annual_financials
ORDER BY fiscal_year;


-- =====================================================
-- Query 05: Average Profit Margins
-- Business Question:
-- What are Apple's average Net and Operating
-- Profit Margins across the available period?
-- =====================================================

SELECT
    ROUND(
        AVG(Net_Income / NULLIF(Revenue, 0)) * 100,
        2
    ) AS Average_Net_Profit_Margin,
    ROUND(
        AVG(Operating_Income / NULLIF(Revenue, 0)) * 100,
        2
    ) AS Average_Operating_Profit_Margin
FROM annual_financials;


-- =====================================================
-- End of Module 02: Profitability Analysis
-- =====================================================

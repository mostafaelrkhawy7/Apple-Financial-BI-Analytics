
-- =====================================================
-- Project: Apple Financial Analysis
-- Module 06: SQL Views
-- View 01: Revenue Analysis
-- =====================================================

USE apple_financials;


-- Create Revenue Analysis View

CREATE OR REPLACE VIEW vw_revenue_analysis AS

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

    Revenue,

    ROUND(
        Revenue / 1000000000,
        2
    ) AS Revenue_Billions,

    Previous_Revenue,

    ROUND(
        (
            (Revenue - Previous_Revenue)
            / NULLIF(Previous_Revenue, 0)
        ) * 100,
        2
    ) AS Revenue_Growth_Percentage

FROM Revenue_Trend;


-- Test the View

SELECT *
FROM vw_revenue_analysis
ORDER BY fiscal_year;

-- Test the View

SELECT * FROM vw_revenue_analysis;


-- =====================================================
-- View 02: Profitability Analysis
-- =====================================================

CREATE OR REPLACE VIEW vw_profitability_analysis AS

SELECT
    fiscal_year,

    Revenue,
    Net_Income,
    Operating_Income,

    ROUND(
        Net_Income / NULLIF(Revenue, 0) * 100,
        2
    ) AS Net_Profit_Margin,

    ROUND(
        Operating_Income / NULLIF(Revenue, 0) * 100,
        2
    ) AS Operating_Profit_Margin

FROM annual_financials;


-- Test the View

SELECT *
FROM vw_profitability_analysis
ORDER BY fiscal_year;


-- =====================================================
-- View 03: Financial Position Analysis
-- Business Question:
-- How has Apple's financial position evolved?
-- =====================================================

CREATE OR REPLACE VIEW vw_financial_position AS

SELECT
    fiscal_year,

    Total_Assets,
    Total_Liabilities,

    -- Calculate Shareholders' Equity
    (Total_Assets - Total_Liabilities) AS Total_Equity,

    -- Convert financial values to Billions
    ROUND(Total_Assets / 1000000000, 2)
        AS Total_Assets_Billions,

    ROUND(Total_Liabilities / 1000000000, 2)
        AS Total_Liabilities_Billions,

    ROUND(
        (Total_Assets - Total_Liabilities) / 1000000000,
        2
    ) AS Total_Equity_Billions,

    -- Liabilities to Assets Ratio
    ROUND(
        Total_Liabilities / NULLIF(Total_Assets, 0) * 100,
        2
    ) AS Liabilities_to_Assets_Percentage,

    -- Equity Ratio
    ROUND(
        (Total_Assets - Total_Liabilities)
        / NULLIF(Total_Assets, 0) * 100,
        2
    ) AS Equity_Ratio_Percentage

FROM annual_financials

WHERE Total_Assets IS NOT NULL
  AND Total_Liabilities IS NOT NULL;


-- Test the View

SELECT *
FROM vw_financial_position
ORDER BY fiscal_year;


-- =====================================================
-- View 04: Growth Analysis
-- Business Question:
-- How are Apple's financial metrics growing
-- year over year?
-- =====================================================

CREATE OR REPLACE VIEW vw_growth_analysis AS

WITH Financial_Growth AS (
    SELECT
        fiscal_year,
        Revenue,
        Net_Income,
        Operating_Income,
        Total_Assets,
        Total_Liabilities,

        LAG(Revenue) OVER (
            ORDER BY fiscal_year
        ) AS Previous_Revenue,

        LAG(Net_Income) OVER (
            ORDER BY fiscal_year
        ) AS Previous_Net_Income,

        LAG(Operating_Income) OVER (
            ORDER BY fiscal_year
        ) AS Previous_Operating_Income,

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

    -- Revenue Growth
    ROUND(
        (Revenue - Previous_Revenue)
        / NULLIF(Previous_Revenue, 0) * 100,
        2
    ) AS Revenue_Growth_Percentage,

    -- Net Income Growth
    ROUND(
        (Net_Income - Previous_Net_Income)
        / NULLIF(Previous_Net_Income, 0) * 100,
        2
    ) AS Net_Income_Growth_Percentage,

    -- Operating Income Growth
    ROUND(
        (Operating_Income - Previous_Operating_Income)
        / NULLIF(Previous_Operating_Income, 0) * 100,
        2
    ) AS Operating_Income_Growth_Percentage,

    -- Assets Growth
    ROUND(
        (Total_Assets - Previous_Assets)
        / NULLIF(Previous_Assets, 0) * 100,
        2
    ) AS Assets_Growth_Percentage,

    -- Liabilities Growth
    ROUND(
        (Total_Liabilities - Previous_Liabilities)
        / NULLIF(Previous_Liabilities, 0) * 100,
        2
    ) AS Liabilities_Growth_Percentage

FROM Financial_Growth;


-- Test the View

SELECT *
FROM vw_growth_analysis
ORDER BY fiscal_year;


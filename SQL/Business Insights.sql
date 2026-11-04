
-- =====================================================
-- Project: Apple Financial Analysis
-- Module 05: Business Insights
-- Database: apple_financials
-- Description: Generate business insights from
-- Apple's historical financial performance
-- =====================================================

USE apple_financials;


-- =====================================================
-- Query 01: Financial Performance Overview
-- Business Question:
-- What is Apple's overall financial performance
-- across Revenue, Net Income, and Operating Income?
-- =====================================================

SELECT
    fiscal_year,

    ROUND(Revenue / 1000000000, 2) AS Revenue_Billions,

    ROUND(Net_Income / 1000000000, 2) AS Net_Income_Billions,

    ROUND(Operating_Income / 1000000000, 2)
        AS Operating_Income_Billions,

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
-- Query 02: Best Revenue Growth Year
-- Business Question:
-- Which fiscal year recorded the highest
-- year-over-year Revenue Growth?
-- =====================================================

WITH Revenue_Growth AS (
    SELECT
        fiscal_year,
        Revenue,

        LAG(Revenue) OVER (
            ORDER BY fiscal_year
        ) AS Previous_Revenue

    FROM annual_financials
),

Growth_Results AS (
    SELECT
        fiscal_year,

        ROUND(
            (
                (Revenue - Previous_Revenue)
                / NULLIF(Previous_Revenue, 0)
            ) * 100,
            2
        ) AS Revenue_Growth_Percentage

    FROM Revenue_Growth
)

SELECT
    fiscal_year,
    Revenue_Growth_Percentage
FROM Growth_Results
WHERE Revenue_Growth_Percentage IS NOT NULL
ORDER BY Revenue_Growth_Percentage DESC
LIMIT 1;


-- =====================================================
-- Query 03: Best Net Profit Margin Year
-- Business Question:
-- Which fiscal year achieved the highest
-- Net Profit Margin?
-- =====================================================

SELECT
    fiscal_year,

    ROUND(
        Net_Income / NULLIF(Revenue, 0) * 100,
        2
    ) AS Net_Profit_Margin

FROM annual_financials
ORDER BY Net_Profit_Margin DESC
LIMIT 1;


-- =====================================================
-- Query 04: Financial Position Overview
-- Business Question:
-- How has Apple's financial position evolved?
-- =====================================================

SELECT
    fiscal_year,

    ROUND(Total_Assets / 1000000000, 2)
        AS Total_Assets_Billions,

    ROUND(Total_Liabilities / 1000000000, 2)
        AS Total_Liabilities_Billions,

    ROUND(
        (Total_Assets - Total_Liabilities) / 1000000000,
        2
    ) AS Total_Equity_Billions,

    ROUND(
        Total_Liabilities / NULLIF(Total_Assets, 0) * 100,
        2
    ) AS Liabilities_to_Assets_Percentage

FROM annual_financials

WHERE Total_Assets IS NOT NULL
  AND Total_Liabilities IS NOT NULL

ORDER BY fiscal_year;


-- =====================================================
-- Query 05: Latest Available Financial Performance
-- Business Question:
-- What are Apple's financial results in the
-- latest available fiscal year in this dataset?
-- =====================================================

SELECT
    fiscal_year,

    ROUND(Revenue / 1000000000, 2)
        AS Revenue_Billions,

    ROUND(Net_Income / 1000000000, 2)
        AS Net_Income_Billions,

    ROUND(Operating_Income / 1000000000, 2)
        AS Operating_Income_Billions,

    ROUND(
        Net_Income / NULLIF(Revenue, 0) * 100,
        2
    ) AS Net_Profit_Margin,

    ROUND(
        Operating_Income / NULLIF(Revenue, 0) * 100,
        2
    ) AS Operating_Profit_Margin

FROM annual_financials
ORDER BY fiscal_year DESC
LIMIT 1;


-- =====================================================
-- End of Module 05: Business Insights
-- =====================================================

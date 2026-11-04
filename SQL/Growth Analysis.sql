
-- =====================================================
-- Project: Apple Financial Analysis
-- Module 04: Growth Analysis
-- Database: apple_financials
-- Description: Analyze Apple's financial growth trends
-- =====================================================

USE apple_financials;


-- =====================================================
-- Query 01: Revenue Growth
-- Business Question:
-- How fast is Apple's Revenue growing year over year?
-- =====================================================

WITH Revenue_Growth AS (
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
    ROUND(
        (
            (Revenue - Previous_Revenue)
            / NULLIF(Previous_Revenue, 0)
        ) * 100,
        2
    ) AS Revenue_Growth_Percentage
FROM Revenue_Growth
ORDER BY fiscal_year;


-- =====================================================
-- Query 02: Net Income Growth
-- Business Question:
-- Is Apple's Net Income growing year over year?
-- =====================================================

WITH Net_Income_Growth AS (
    SELECT
        fiscal_year,
        Net_Income,
        LAG(Net_Income) OVER (
            ORDER BY fiscal_year
        ) AS Previous_Net_Income
    FROM annual_financials
)

SELECT
    fiscal_year,
    ROUND(Net_Income / 1000000000, 2) AS Net_Income_Billions,
    ROUND(
        (
            (Net_Income - Previous_Net_Income)
            / NULLIF(Previous_Net_Income, 0)
        ) * 100,
        2
    ) AS Net_Income_Growth_Percentage
FROM Net_Income_Growth
ORDER BY fiscal_year;


-- =====================================================
-- Query 03: Operating Income Growth
-- Business Question:
-- How fast is Apple's Operating Income growing?
-- =====================================================

WITH Operating_Income_Growth AS (
    SELECT
        fiscal_year,
        Operating_Income,
        LAG(Operating_Income) OVER (
            ORDER BY fiscal_year
        ) AS Previous_Operating_Income
    FROM annual_financials
)

SELECT
    fiscal_year,
    ROUND(Operating_Income / 1000000000, 2) AS Operating_Income_Billions,
    ROUND(
        (
            (Operating_Income - Previous_Operating_Income)
            / NULLIF(Previous_Operating_Income, 0)
        ) * 100,
        2
    ) AS Operating_Income_Growth_Percentage
FROM Operating_Income_Growth
ORDER BY fiscal_year;


-- =====================================================
-- Query 04: Assets and Liabilities Growth Comparison
-- Business Question:
-- Are Apple's Assets and Liabilities growing
-- at the same rate?
-- =====================================================

WITH Financial_Growth AS (
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

FROM Financial_Growth
ORDER BY fiscal_year;


-- =====================================================
-- Query 05: Combined Financial Growth
-- Business Question:
-- How do Revenue, Net Income, and Operating Income
-- growth rates compare year over year?
-- =====================================================

WITH Financial_Growth AS (
    SELECT
        fiscal_year,
        Revenue,
        Net_Income,
        Operating_Income,

        LAG(Revenue) OVER (
            ORDER BY fiscal_year
        ) AS Previous_Revenue,

        LAG(Net_Income) OVER (
            ORDER BY fiscal_year
        ) AS Previous_Net_Income,

        LAG(Operating_Income) OVER (
            ORDER BY fiscal_year
        ) AS Previous_Operating_Income

    FROM annual_financials
)

SELECT
    fiscal_year,

    ROUND(
        (
            (Revenue - Previous_Revenue)
            / NULLIF(Previous_Revenue, 0)
        ) * 100,
        2
    ) AS Revenue_Growth_Percentage,

    ROUND(
        (
            (Net_Income - Previous_Net_Income)
            / NULLIF(Previous_Net_Income, 0)
        ) * 100,
        2
    ) AS Net_Income_Growth_Percentage,

    ROUND(
        (
            (Operating_Income - Previous_Operating_Income)
            / NULLIF(Previous_Operating_Income, 0)
        ) * 100,
        2
    ) AS Operating_Income_Growth_Percentage

FROM Financial_Growth
ORDER BY fiscal_year;


-- =====================================================
-- End of Module 04: Growth Analysis
-- =====================================================

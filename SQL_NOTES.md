# SQL Learning Notes

This file summarises the main SQL concepts used in the USD/ZAR Market Relationship Analysis project.

## SELECT
Used to choose which columns or calculations to return.

Example:
SELECT date, usdzar, gold_close
FROM project.dataset.table;

## WHERE
Used to filter rows.

Example:
WHERE usdzar IS NOT NULL;

## ORDER BY
Used to sort results.

Example:
ORDER BY date;

## AS
Used to create an alias for a column or table.

Example:
u.DEXSFUS AS usdzar

## COUNT
Used to count observations.

Example:
COUNT(*) AS observation_count

## COUNTIF
Used to count rows that meet a condition.

Example:
COUNTIF(usdzar_forward_20d > 0)

## AVG
Used to calculate an average.

Example:
AVG(usdzar_forward_20d)

## ROUND
Used to control the number of decimal places displayed.

Example:
ROUND(AVG(usdzar_forward_20d), 3)

## LEFT JOIN
Used to combine tables while keeping all rows from the left-hand table.

Example:
LEFT JOIN project.dataset.gold_raw g
ON u.observation_date = g.Date

## CASE WHEN
Used to create categories based on conditions.

Example:
CASE
  WHEN usd_index_return_pct >= 0.5
       AND sp500_return_pct <= -1.0
    THEN 'USD up + S&P down'
  ELSE 'Other'
END

## LAG
Used to access a previous observation.

In this project it was used to calculate daily percentage returns.

Example:
LAG(usdzar) OVER (ORDER BY date)

## LEAD
Used to access a future observation.

In this project it was used to calculate forward USD/ZAR returns.

Example:
LEAD(usdzar, 20) OVER (ORDER BY date)

## Window Functions
OVER (ORDER BY date) tells SQL to perform the calculation in chronological order.

## CORR
Used to calculate the correlation between two variables.

Example:
CORR(usdzar_return_pct, usd_index_return_pct)

## CREATE OR REPLACE TABLE
Used to create a new table or replace an existing version.

## IS NULL / IS NOT NULL
Used to test for missing values.

Example:
WHERE usdzar IS NOT NULL

## EXTRACT
Used to extract part of a date.

Example:
EXTRACT(YEAR FROM date)

## GROUP BY
Used to group rows so summary calculations can be performed for each category.

Example:
GROUP BY combined_signal

## WITH
Used to create a temporary named query step.

This helps make longer SQL queries easier to read.

## UNION ALL
Used to combine the results of multiple queries while keeping all rows.

## CROSS JOIN
Used during threshold testing to compare different combinations of values.

## Percentage Return Calculation
The basic return calculation used in this project was:

100 * (current_value / previous_value - 1)

## Concepts Used During the Project

- SELECT
- FROM
- WHERE
- ORDER BY
- GROUP BY
- AS
- COUNT
- COUNTIF
- AVG
- MIN
- MAX
- ROUND
- CORR
- CASE WHEN
- CREATE OR REPLACE TABLE
- LEFT JOIN
- WITH
- Window functions
- LAG
- LEAD
- EXTRACT
- UNION ALL
- CROSS JOIN
- IS NULL
- IS NOT NULL
- Percentage-return calculations
- Conditional analysis
- Threshold testing
- Split-period analysis

## Learning Note

I used AI assistance and documentation while writing and debugging SQL during this project.

My goal is to understand the logic behind the queries and gradually become less dependent on assistance for repeated SQL concepts.

The hands-on work in BigQuery and Tableau was completed by me, while AI was used as a learning and project-support tool.

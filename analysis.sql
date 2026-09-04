-- USD/ZAR Market Relationship Analysis
-- BigQuery project: sgl-practice
-- Dataset: usdzar_analysis

-- 1. Join source tables
CREATE OR REPLACE TABLE `sgl-practice.usdzar_analysis.market_joined` AS
SELECT
  u.observation_date AS date,
  u.DEXSFUS AS usdzar,
  g.Close AS gold_close,
  d.DTWEXBGS AS usd_index,
  s.SP500 AS sp500
FROM `sgl-practice.usdzar_analysis.usdzar_raw` u
LEFT JOIN `sgl-practice.usdzar_analysis.gold_raw` g
  ON u.observation_date = g.Date
LEFT JOIN `sgl-practice.usdzar_analysis.usd_index_raw` d
  ON u.observation_date = d.observation_date
LEFT JOIN `sgl-practice.usdzar_analysis.sp500_raw` s
  ON u.observation_date = s.observation_date
WHERE u.observation_date >= '2016-09-01'
ORDER BY date;


-- 2. Keep complete observations
CREATE OR REPLACE TABLE `sgl-practice.usdzar_analysis.market_clean` AS
SELECT
  date,
  usdzar,
  gold_close,
  usd_index,
  sp500
FROM `sgl-practice.usdzar_analysis.market_joined`
WHERE usdzar IS NOT NULL
  AND gold_close IS NOT NULL
  AND usd_index IS NOT NULL
  AND sp500 IS NOT NULL
ORDER BY date;


-- 3. Calculate daily percentage returns
CREATE OR REPLACE TABLE `sgl-practice.usdzar_analysis.market_returns` AS
SELECT
  date,
  usdzar,
  gold_close,
  usd_index,
  sp500,

  100 * (
    usdzar / LAG(usdzar) OVER (ORDER BY date) - 1
  ) AS usdzar_return_pct,

  100 * (
    gold_close / LAG(gold_close) OVER (ORDER BY date) - 1
  ) AS gold_return_pct,

  100 * (
    usd_index / LAG(usd_index) OVER (ORDER BY date) - 1
  ) AS usd_index_return_pct,

  100 * (
    sp500 / LAG(sp500) OVER (ORDER BY date) - 1
  ) AS sp500_return_pct

FROM `sgl-practice.usdzar_analysis.market_clean`
ORDER BY date;


-- 4. Same-day correlations
SELECT
  CORR(usdzar_return_pct, gold_return_pct) AS corr_usdzar_gold,
  CORR(usdzar_return_pct, usd_index_return_pct) AS corr_usdzar_usd_index,
  CORR(usdzar_return_pct, sp500_return_pct) AS corr_usdzar_sp500
FROM `sgl-practice.usdzar_analysis.market_returns`
WHERE usdzar_return_pct IS NOT NULL;


-- 5. Forward USD/ZAR returns
CREATE OR REPLACE TABLE `sgl-practice.usdzar_analysis.forward_returns` AS
SELECT
  date,
  usdzar,
  gold_return_pct,
  usd_index_return_pct,
  sp500_return_pct,

  100 * (
    LEAD(usdzar, 5) OVER (ORDER BY date) / usdzar - 1
  ) AS usdzar_forward_5d,

  100 * (
    LEAD(usdzar, 10) OVER (ORDER BY date) / usdzar - 1
  ) AS usdzar_forward_10d,

  100 * (
    LEAD(usdzar, 20) OVER (ORDER BY date) / usdzar - 1
  ) AS usdzar_forward_20d

FROM `sgl-practice.usdzar_analysis.market_returns`
ORDER BY date;


-- 6. Combined market-condition analysis
SELECT
  CASE
    WHEN usd_index_return_pct >= 0.5
         AND sp500_return_pct <= -1.0
      THEN 'USD up + S&P down'

    WHEN usd_index_return_pct <= -0.5
         AND sp500_return_pct >= 1.0
      THEN 'USD down + S&P up'

    ELSE 'Other'
  END AS combined_signal,

  COUNT(*) AS observation_count,

  ROUND(AVG(usdzar_forward_5d), 3) AS avg_forward_5d,
  ROUND(AVG(usdzar_forward_10d), 3) AS avg_forward_10d,
  ROUND(AVG(usdzar_forward_20d), 3) AS avg_forward_20d,

  ROUND(
    100 * COUNTIF(usdzar_forward_20d > 0) / COUNT(*),
    1
  ) AS pct_higher_20d,

  ROUND(
    100 * COUNTIF(usdzar_forward_20d < 0) / COUNT(*),
    1
  ) AS pct_lower_20d

FROM `sgl-practice.usdzar_analysis.forward_returns`

WHERE usdzar_forward_20d IS NOT NULL

GROUP BY combined_signal
ORDER BY observation_count DESC;


-- 7. Create Tableau-ready output
CREATE OR REPLACE TABLE `sgl-practice.usdzar_analysis.tableau_analysis` AS
SELECT
  f.date,
  f.usdzar,
  r.usdzar_return_pct,
  f.gold_return_pct,
  f.usd_index_return_pct,
  f.sp500_return_pct,
  f.usdzar_forward_5d,
  f.usdzar_forward_10d,
  f.usdzar_forward_20d,

  CASE
    WHEN f.usd_index_return_pct >= 0.5
         AND f.sp500_return_pct <= -1.0
      THEN 'USD up + S&P down'

    WHEN f.usd_index_return_pct <= -0.5
         AND f.sp500_return_pct >= 1.0
      THEN 'USD down + S&P up'

    ELSE 'Other'
  END AS combined_signal,

  CASE
    WHEN f.usdzar_forward_20d > 0 THEN 'USD/ZAR higher'
    WHEN f.usdzar_forward_20d < 0 THEN 'USD/ZAR lower'
    ELSE 'Flat'
  END AS outcome_20d,

  EXTRACT(YEAR FROM f.date) AS year

FROM `sgl-practice.usdzar_analysis.forward_returns` f

LEFT JOIN `sgl-practice.usdzar_analysis.market_returns` r
  ON f.date = r.date

WHERE f.usdzar_forward_20d IS NOT NULL

ORDER BY f.date;

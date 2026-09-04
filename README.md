# USD/ZAR Market Relationship Analysis

![USD/ZAR Tableau Dashboard](dashboard.png)

## Project Overview

This project explores whether historical movements in the broad US dollar index, gold, and the S&P 500 provide useful context for the direction of USD/ZAR over approximately a one-month horizon.

The business use case is relevant to an export environment where USD receipts may need to be converted into South African rand (ZAR), and where understanding market conditions can help support conversion-timing decisions.

The analysis is intended as a business analytics project rather than a trading or forecasting model.

---

## Business Question

**Can historical movements in gold, broad USD strength, and the S&P 500 provide useful context for the likely direction of USD/ZAR over approximately the next month?**

---

## Data

Daily market data was collected for:

- USD/ZAR exchange rate
- Gold price
- Broad US Dollar Index
- S&P 500

The common analysis period was approximately:

**September 2016 to August 2026**

After aligning the datasets and removing rows with missing values, the cleaned dataset contained approximately **2,480 observations**.

### Sources

- Federal Reserve Economic Data (FRED) – USD/ZAR
- Federal Reserve Economic Data (FRED) – Broad US Dollar Index
- Federal Reserve Economic Data (FRED) – S&P 500
- Stooq – Gold price data

The FRED broad dollar index was used as a broad measure of USD strength and should not be interpreted as the ICE DXY index.

---

## Tools Used

- **Google BigQuery** – data cleaning, joins and analysis
- **SQL** – calculations, correlations, lag/lead analysis and conditional analysis
- **Tableau Public** – dashboard and visualisation

---

## Analysis Process

The project followed the Google Data Analytics framework:

### Ask
Defined the business question around USD/ZAR conversion timing.

### Prepare
Collected historical data for USD/ZAR, gold, broad USD strength and the S&P 500.

### Process
Imported datasets into BigQuery, checked data types, aligned dates and removed incomplete observations.

### Analyze

The analysis included:

- Daily percentage returns
- Same-day correlations
- Lead/lag relationships
- 5-, 10- and approximately 20-observation forward USD/ZAR returns
- Conditional market scenarios
- Combined USD-strength and equity-market signals
- Split-period testing
- Threshold sensitivity testing

### Share
Results were visualised in Tableau Public.

### Act
Findings were interpreted in the context of export-related USD-to-ZAR conversion decisions.

---

## Key Findings

### Same-Day Relationships

Daily USD/ZAR returns showed:

- A relatively strong positive relationship with the broad USD index
- A weaker negative relationship with gold
- A weaker negative relationship with the S&P 500

The broad USD index had the strongest same-day relationship with USD/ZAR.

### Lead/Lag Analysis

Testing market variables at 1-, 2-, 3-, 5- and 10-observation lags showed very weak relationships with future USD/ZAR daily returns.

This suggests that the strongest relationships were generally **contemporaneous rather than clearly predictive several days in advance**.

### Combined Market Condition

One historical condition examined was:

**Broad USD index rising strongly while the S&P 500 declined strongly**

Using thresholds of approximately:

- Broad USD index: **+0.5% or more**
- S&P 500: **-1.0% or less**

This condition occurred **42 times** in the dataset.

On average, USD/ZAR was approximately:

- **0.45% lower after 5 observations**
- **0.66% lower after 10 observations**
- **0.78% lower after 20 observations**

USD/ZAR was lower after approximately 20 observations in about **69% of these historical cases**.

The result remained directionally similar when the dataset was divided into earlier and later periods, although the number of observations was small.

---

## Interpretation

The analysis suggests that broad USD strength and global equity-market sentiment can provide useful context when assessing USD/ZAR.

However, the relationships do not provide a reliable standalone forecasting rule.

The strongest same-day relationship was between USD/ZAR and broad USD strength, while lead/lag testing provided little evidence that these markets consistently predict USD/ZAR several days in advance.

The combined USD-strength / S&P 500 condition produced an interesting longer-horizon historical pattern, but the relatively small sample means it should be treated as contextual information rather than a deterministic signal.

---

## Dashboard

View the interactive Tableau dashboard:

[USD/ZAR Market Relationship Analysis – Tableau Public](https://public.tableau.com/app/profile/colin.huysamen/viz/USDZARMarketRelationshipAnalysis/USDZARMarketRelationshipAnalysis#1)

The dashboard includes:

- USD/ZAR historical trend
- Average 20-observation USD/ZAR move by market condition
- Directional outcome consistency
- USD Index vs USD/ZAR daily return relationship

---

## Limitations

Several limitations should be considered:

- Historical relationships do not guarantee future results.
- Correlation does not establish causation.
- Some conditional scenarios contain relatively small sample sizes.
- Market relationships can change over time.
- The broad USD index used is not the ICE DXY index.
- The analysis used complete-case observations across multiple datasets.
- Therefore, a "20-observation" forward return represents 20 aligned observations in the cleaned dataset and may not always equal exactly 20 consecutive market trading days.
- Transaction costs, exchange spreads, operational requirements and business cash-flow constraints were not included.
- The project does not constitute financial or trading advice.

---

## Skills Demonstrated

This project demonstrates practical experience with:

- Business-question development
- Data sourcing and preparation
- SQL joins
- Data cleaning
- Window functions
- `LAG()` and `LEAD()`f
- Percentage-return calculations
- Correlation analysis
- Conditional analysis
- Split-period validation
- Tableau dashboard development
- Translating analytical findings into business context

---

## AI Assistance

I used AI as a learning and project-support tool during this analysis.

It assisted with:

- Structuring the analytical workflow
- Drafting and debugging SQL queries
- Explaining SQL syntax and errors
- Discussing analytical approaches
- Interpreting results

I performed the hands-on work in BigQuery and Tableau, reviewed the outputs, and made project decisions based on the results.

This project reflects my developing SQL and data-analysis skills and should not be interpreted as a claim of expert-level SQL proficiency.

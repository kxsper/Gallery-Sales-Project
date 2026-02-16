# Gallery Sales Data Cleaning Project

**Cleaned_Gallery_Sales_Data** – A cleaned version of dirty gallery sales records.

Current date context: February 2026

## Project Overview

This project takes a dirty Python generated CSV export (`Dirty_Gallery_Sales_Data.csv`), which mimics an art gallery’s sales system and transforms it into a clean, consistent and reliable dataset suitable for reporting, dashboards, financial analysis and machine learning.
The end goal is to analyse the cleaned data to generate actionable insights and meaningful KPIs that support data driven business decisions.

**Original data issues included:**
- Duplicate sale records (marked with `_dup` suffix)
- Inconsistent artist name spelling
- Mixed age group formats (e.g. "35 - 44", "45to54", "55 plus", "UNK")
- Missing or suspicious `Total_GBP` values
- Occasional invalid unit prices (`Price_GBP` ≤ 0)
- String inconsistencies (leading/trailing spaces)

**Goals achieved:**
- Single clean table: `Cleaned_Gallery_Sales_Data`
- 420 unique transactions (from original 460 rows)
- Unique `Sale_ID` primary key
- Full `YYYY-MM-DD` dates preserved
- Repaired monetary values
- Standardised categories

## Key Cleaning Steps Performed

- **Deduplication**  
  Removed logical duplicates by preferring non-`_dup` versions (using window function + `rn = 1` filter)

- **Date Handling**  
  Ensured `SaleDate` is consistently stored as full `YYYY-MM-DD` text (explicit string validation & preservation)

- **Monetary Repairs**  
  - Recalculated `Total_GBP` when missing, empty, or suspiciously near zero  
  - Back-calculated `Price_GBP` when invalid (≤ 0 but money moved)  
  - Rounded consistently to 2 decimal places

- **Standardisation & Cleaning**  
  - Trimmed all text fields  
  - Light artist name fixes (e.g. "Andrei P" → "Andrei Protsouk")  
  - Simplified age group normalisation (35-44, 45-54, 55+, Unknown, etc.)  
  - Filtered out clearly invalid rows

- **Kept intentionally**  
  Negative quantities (real returns/refunds)  
  Future dates (2025–2026 entries appear valid in context)
  
## Insights and Meaningful KPIs Using the Cleaned Data

### Total Revenue

- £891,728.05

Represents total sales value across all transactions.

### Number of Transactions

- 420 transactions

Reflects total completed sales after data validation.

### Average Order Value (AOV)

- £2,123.16

The average value of each transaction, indicating strong high-value purchases.

### Customer Mix
- New	286
- Repeat	134

68% New / 32% Repeat

Indicates strong acquisition performance with an opportunity to improve customer retention.

### Return Rate

- 1.9% of transactions

Low return rate suggests high customer satisfaction and strong product fit.

### Payment Method Distribution
- Credit Card	74.5%
- Cash	16.9%
- Bank Transfer	8.6%

Digital payments dominate, supporting online and card-first sales strategies.

### Revenue Performance Insights
Top 5 Artists by Revenue
1. Craig Alan £86,707.66
2. Alexander Weaver	£75,787.71
3. Doug Hyde	£73,308.67
4. Rozanne Bell	£68,620.41
5. Jeff Rowland	£64,500.11

A small group of artists generates a significant share of total revenue, highlighting a Pareto effect.

### Revenue by Age Group
- 35–44	£273,938.54
- 25–34	£193,058.80
- 45–54	£176,827.02
- 18–24	£99,054.06
- 55+	£82,612.21

Customers aged 25–44 generate the majority of revenue, making them the core target demographic.

## Key Business Insights 
**1. Strong Revenue Performance**

With nearly £900k in sales, the gallery demonstrates strong commercial viability.
The high average order value indicates customers are willing to invest in premium artwork.

**2. Acquisition vs Retention Opportunity**

Although new customers dominate (68%), only 32% return.
This highlights opportunities for:
- Loyalty programmes
- VIP previews
- Repeat-buyer incentives

**3. Revenue Concentration Risk**

Top artists generate a disproportionate share of revenue.
While beneficial, this creates dependency risk if key artists leave.
- Recommendation: Diversify promotion across mid-performing artists.

**4. Digitally-Driven Sales**

Over 74% of payments use credit cards, confirming:
- Strong digital readiness
- Potential for online expansion
- Low reliance on cash

**5. High Customer Satisfaction**

The low return rate (1.9%) indicates:
- Accurate product descriptions
- Strong buyer satisfaction
- Good pricing alignment

**6. Clearly Defined Core Customer Segment**
Buyers aged 25–44 drive most revenue.
Marketing Implication:
- Focus exhibitions, social media campaigns, and advertising toward this demographic.

## Recommended KPIs for Ongoing Monitoring

This dataset supports long-term business tracking using the following KPIs:
- Total Revenue	Overall financial performance
- Average Order Value	Customer spending behaviour
- Repeat Purchase Rate	Retention strength
- Artist Revenue Share	Portfolio balance
- Return Rate	Product satisfaction
- Revenue by Age Group	Market segmentation
- Payment Mix	Transaction preferences

## Files in this Repository

| File                                   | Description                                      |
|----------------------------------------|--------------------------------------------------|
| `Dirty_Gallery_Sales_Data.csv`         | Original dirty generated file                    |
| `Cleaned_Gallery_Sales_Data.csv`       | Cleaned table                                    |
| `Clean_Gallery_Sales_Data.sql`         | Full SQL script to create the clean table        |
| `Generate_Dirty_Gallery_Sales_Data.py` | Full Python script to gennerate the dirty file   |
| `README.md`                            | Current file                                     |

## How to Use

1. Load the original dirty CSV into your database as table `Dirty_Gallery_Sales_Data.csv`  
   (SQLite, PostgreSQL, MySQL, DuckDB, etc.)

2. Run the cleaning script:
   ```bash
   sqlite3 gallery.db < Clean_Gallery_Sales_Data.sql

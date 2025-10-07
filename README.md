# Walmart Sales Data Analysis

## About the Project

This project explores **Walmart sales data** to understand:

* Top-performing branches and products
* Sales trends across departments
* Customer behavior
* Opportunities to improve sales strategies

The dataset comes from the **Kaggle Walmart Sales Forecasting Competition**, which provides historical sales for 45 Walmart stores across multiple regions, including holiday markdown events that impact sales.

---

## Purpose

The main goal is to gain insights into factors affecting sales across different Walmart branches and identify strategies to optimize performance.

---

## Dataset

The dataset includes **1000 rows and 17 columns** from three branches: Mandalay, Yangon, and Naypyitaw.

| Column                  | Description                | Data Type     |
| ----------------------- | -------------------------- | ------------- |
| invoice_id              | Invoice of the sale        | VARCHAR(30)   |
| branch                  | Branch where sale occurred | VARCHAR(5)    |
| city                    | Branch location            | VARCHAR(30)   |
| customer_type           | Type of customer           | VARCHAR(30)   |
| gender                  | Gender of customer         | VARCHAR(10)   |
| product_line            | Product line sold          | VARCHAR(100)  |
| unit_price              | Price per unit             | DECIMAL(10,2) |
| quantity                | Units sold                 | INT           |
| VAT                     | Tax on purchase            | FLOAT(6,4)    |
| total                   | Total purchase cost        | DECIMAL(10,2) |
| date                    | Purchase date              | DATE          |
| time                    | Purchase time              | TIMESTAMP     |
| payment_method          | Payment type               | VARCHAR(20)   |
| cogs                    | Cost of goods sold         | DECIMAL(10,2) |
| gross_margin_percentage | Gross margin %             | FLOAT(11,9)   |
| gross_income            | Gross income               | DECIMAL(10,2) |
| rating                  | Customer rating            | FLOAT(2,1)    |

---

## Analyses Conducted

### 1. Product Analysis

* Identify top-performing and underperforming product lines
* Determine revenue contribution of each product

### 2. Sales Analysis

* Examine sales trends across time, day, and month
* Evaluate effectiveness of sales strategies

### 3. Customer Analysis

* Explore customer segments and purchasing behavior
* Analyze profitability of each customer type

---

## Approach

1. **Data Wrangling**:

   * Checked for NULL/missing values (database set `NOT NULL` for all fields).

2. **Database Setup**:

   * Created tables and inserted data into MySQL.

3. **Feature Engineering**:

   * Added `time_of_day` (Morning, Afternoon, Evening)
   * Added `day_name` (Mon–Sun)
   * Added `month_name` (Jan–Dec)

4. **Exploratory Data Analysis (EDA)**:

   * Visualized key trends using Python for easy insights

---

## Key Metrics & Calculations

* **COGS** = `unit_price * quantity`
* **VAT** = `5% of COGS`
* **Total (Gross Sales)** = `COGS + VAT`
* **Gross Profit (Income)** = `Total - COGS`
* **Gross Margin %** = `gross income / total revenue`

**Example:**

* Unit Price = 45.79, Quantity = 7
* COGS = 45.79 × 7 = 320.53
* VAT = 5% × 320.53 = 16.03
* Total = 320.53 + 16.03 = 336.56
* Gross Margin % = 16.03 / 336.56 ≈ 4.76%

---

## Business Questions Answered

**Products:**

* Most common product line & payment method
* Product line with highest revenue & VAT
* Branches performing above average

**Sales:**

* Sales by time of day, day of week, and month
* Customer types generating most revenue & VAT

**Customers:**

* Gender and customer type distribution
* Ratings trends by time and branch

---

## Tools Used

* **MySQL**: Database management
* **Python**: Data visualization and EDA

---





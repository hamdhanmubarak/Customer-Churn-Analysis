# 📊 Amazon's Subscription Churn Analysis Dashboard (SQL + Power BI)

## 📌 Project Overview

Customer churn is a critical challenge for SaaS and subscription-based businesses. This project focuses on identifying **churn risk**, understanding **why customers churn**, and quantifying **revenue impact** using **SQL for data analysis** and **Power BI for visualization**.

The final outcome is an **interactive churn analytics dashboard** that helps stakeholders monitor churn trends, risky customers, and impacted revenue.

---

## 🛠 Tools & Technologies

* **PostgreSQL** – Data storage & churn analysis using SQL
* **SQL** – Data modeling, churn logic, aggregations
* **Power BI** – Data modeling, DAX measures & dashboarding

---

## 📂 Data Model

The analysis is built on the following tables:

| Table Name         | Description                                                  |
| ------------------ | ------------------------------------------------------------ |
| `customers`        | Customer profile details (name, email, country, signup date) |
| `subscriptions`    | Subscription plans, status, start & end dates                |
| `transactions`     | Customer payments and revenue data                           |
| `user_activity`    | Customer engagement events (login, logout, purchase, etc.)   |
| `final_churn_data` | Derived churn classification per customer                    |

**Churn Types Identified:**

* `active` (Low churn risk)
* `financial_churn`
* `engagement_churn`
* `silent_churn`

---

## 🔍 Churn Logic (SQL)

Churn categories were derived using **SQL CTEs and joins**:

* **Financial Churn** → No transactions in last 90 days
* **Engagement Churn** → No login activity in last 90 days
* **Silent Churn** → No activity but subscription still active
* **Active** → Customers not meeting churn conditions

The final churn dataset (`final_churn_data`) was exported and used in Power BI.

---

## 📈 Key Metrics & KPIs

The dashboard highlights:

* **Total Customers**
* **Risky Customers**
* **Average Churn Rate (%)**
* **Impacted Revenue from Low Churn Risk Customers**
* **Customer Status (Active vs Canceled)**

---

## 📊 Power BI Dashboard Features

### 🔹 KPI Cards

* Total Number of Customers
* Risky Customers Count
* Churn Rate (%)
* Impacted Revenue from Low Churn Risk Customers

### 🔹 Visual Analysis

* Churn by Country
* Churn by Subscription Plan
* Customer Status Distribution
* Monthly Transactions by Churn Type
* Churned Customers by Event Type

### 🔹 Filters / Slicers

* Customer Status
* Churn Type
* Subscription Plan Type

---

## 🧮 Key DAX Measures

```DAX
Total Revenue =
SUM(transactions[amount])
```

```DAX
Low Churn Risk Revenue =
CALCULATE(
    [Total Revenue],
    final_churn_data[churn_type] = "active"
)
```

```DAX
Churn Rate (%) =
DIVIDE(
    CALCULATE(COUNT(final_churn_data[customer_id]),
              final_churn_data[churn_type] <> "active"),
    COUNT(final_churn_data[customer_id])
) * 100
```

---

## 💡 Insights Generated

* A large portion of churn is driven by **lack of engagement**
* Certain **countries and plans** have higher churn concentration
* **Active customers generate the majority of stable revenue**
* Revenue at risk can be identified early using behavior patterns

---

## 📁 Repository Structure

```
📦 customer-churn-analysis
 ┣ 📂 sql
 ┃ ┣ churn_analysis.sql
 ┃ ┗ churn_cte_logic.sql
 ┣ 📂 powerbi
 ┃ ┗ customer_churn_dashboard.pbix
 ┣ 📂 data
 ┃ ┗ sample_data.csv
 ┗ README.md
```

---

## 🚀 Future Enhancements

* Predictive churn modeling (Python / ML)
* Customer lifetime value (CLV)
* Cohort analysis
* Automated alerts for high-risk customers

---

## 📬 Contact

If you’d like to discuss this project or collaborate:

**Author:** *Hamdhan Mubarak*
**Role:** Data Analyst
**Skills:** SQL | Power BI | Data Analytics

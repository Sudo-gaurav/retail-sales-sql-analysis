# 📊 Retail Sales SQL Analysis using PostgreSQL

This project is a complete SQL-based analysis of a retail sales dataset, simulating real-world business scenarios in e-commerce and retail. It focuses on extracting business insights using PostgreSQL: revenue trends, customer value, cohort retention, and product performance.

---

## 📁 Dataset Overview

The dataset includes the following columns:

| Column           | Description                         |
|------------------|-------------------------------------|
| `invoice_id`     | Unique invoice number               |
| `customer_id`    | Unique customer identifier          |
| `gender`         | Customer gender                     |
| `age`            | Customer age                        |
| `category`       | Product category                    |
| `quantity`       | Quantity of product sold            |
| `price`          | Unit price                          |
| `payment_method` | Payment method used                 |
| `invoice_date`   | Date of purchase                    |
| `shopping_mall`  | Store or mall location              |

---
## 🎯 Business Objectives

This project answers key business questions:

- 📈 How has revenue grown month-over-month?
- 👥 Who are the top customers by value and frequency?
- 🛍️ Which categories or products are top-performing?
- 💸 Are some products price-sensitive?
- ♻️ What’s the customer retention rate by cohort?

---

## 🛠️ Tools & Technologies

- **PostgreSQL** — for writing and running SQL queries  
- **Excel** — for light data cleaning  
- *(Optional)* Power BI or Tableau for visualizations

---

## 📊 Key Analyses & SQL Logic

### 1. Monthly Revenue Trend

```sql
SELECT DATE_TRUNC('month', invoice_date) AS month,
       ROUND(SUM(quantity * price), 2) AS revenue
FROM sales
GROUP BY 1
ORDER BY 1;
```

---

### 2. Top Customers — RFM Segmentation

```sql
SELECT customer_id,
       MAX(invoice_date) AS last_purchase,
       CURRENT_DATE - MAX(invoice_date) AS recency
FROM sales
GROUP BY customer_id;
```

- **Recency**: Days since last purchase  
- **Frequency**: Total purchases  
- **Monetary**: Total spending  

---

### 3. Price vs Quantity Analysis

Correlated unit price with quantity sold to identify price-sensitive products.

---

### 4. Cohort Retention Analysis

- Grouped users by first purchase month
- Tracked retention in following months

---

### 5. Gender & Age-Based Purchase Trends

Identified which genders and age groups spend more per category.

---

## 📂 Project Structure

```
retail-sales-sql/
│
├── cleaned_dataset.csv
├── retail_sales_analysis.sql
├── rfm_segmentation.sql
├── cohort_retention.sql
├── project-snapshot.png
└── README.md
```

---

## 📌 Use Cases

- SQL Interview Projects / Assessments  
- Analytics Portfolio Projects  
- Retail/FMCG Business Intelligence Demos  
- Cohort, RFM, and Revenue Analysis Practice

---

## 👤 Author

**Gaurav Tawri**  
📬 [LinkedIn](https://www.linkedin.com/in/gauravtawri/)  
🧠 Exploring data analytics, product insights & real-world automation 

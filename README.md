# Indian E-commerce SQL Analysis

**Problem:** Identify revenue drivers, cancellation losses, return patterns, payment-channel risk and high-value customers for an Indian e-commerce business.

## Database
* **Schema:** `indian_ecommerce`
* **Tables:** `customers`, `products`, `sales`
* **Tool:** MySQL Workbench 8.0

## Business Questions
1. Which product categories generate the highest delivered revenue, and how do they rank by investment tier?
2. Which categories lose the most coupon discount value due to cancelled orders?
3. Which categories have the highest volume of returned orders?
4. Which payment channels process the highest realized revenue, and how do their cancellation rates rank by risk?
5. Who are the repeat customers, how much lifetime revenue do they generate, and what loyalty tier do they belong to?

## SQL Concepts Used
INNER JOIN, GROUP BY, HAVING, CASE WHEN (tiering and risk tagging), aggregate functions (SUM, COUNT, AVG), FORMAT, ROUND

## Results

### Q1. Delivered revenue by category

```sql
SELECT p.category,
       FORMAT(SUM(s.quantity), 0) AS total_units_sold,
       FORMAT(SUM(s.total_amount), 2) AS delivered_revenue,
       CASE WHEN SUM(s.total_amount) >= 100000000 THEN 'Core Driver Tier'
            WHEN SUM(s.total_amount) >= 50000000  THEN 'Mid-Tier Performer'
            ELSE 'Underperforming Tier' END AS category_tier
FROM sales s
INNER JOIN products p ON s.Product_ID = p.Product_ID
WHERE s.Order_Status = 'Delivered'
GROUP BY p.category
ORDER BY SUM(s.total_amount) DESC;

### Q2. Lost discount value from cancellations

```sql
SELECT p.Category,
       FORMAT(SUM(s.Coupon_Discount), 2) AS lost_discount_value
FROM sales s
INNER JOIN products p ON s.Product_ID = p.Product_ID
WHERE s.Order_Status = 'Cancelled'
GROUP BY p.Category
ORDER BY SUM(s.Coupon_Discount) DESC;

### Q3. Returned orders by category

```sql
SELECT p.category, 
       FORMAT(COUNT(s.Order_ID), 0) AS returned_orders_count
FROM sales s
INNER JOIN products p ON s.Product_ID = p.Product_ID
WHERE s.Order_Status = 'Returned'
GROUP BY p.Category
ORDER BY COUNT(s.Order_ID) DESC;

### Q4. Payment channel performance

```sql
SELECT Payment_Mode,
       FORMAT(COUNT(order_ID), 0) AS total_orders,
       FORMAT(COUNT(CASE WHEN Order_Status = 'Delivered' THEN 1 END), 0) AS delivered_orders,
       FORMAT(COUNT(CASE WHEN Order_Status = 'Cancelled' THEN 1 END), 0) AS cancelled_orders,
       FORMAT(SUM(CASE WHEN Order_Status = 'Delivered' THEN Total_Amount ELSE 0 END), 2) AS realized_revenue,
       ROUND(SUM(CASE WHEN Order_Status = 'Cancelled' THEN 1 END) / COUNT(Order_ID) * 100, 2) AS cancellation_rate_pct,
       CASE WHEN (COUNT(CASE WHEN Order_Status = 'Cancelled' THEN 1 END) / COUNT(Order_ID)) * 100 > 20 THEN 'High Risk Channel'        
            WHEN (COUNT(CASE WHEN Order_Status = 'Cancelled' THEN 1 END) / COUNT(Order_ID)) * 100 >= 10 THEN 'Moderate Risk Channel'
            ELSE 'Healthy Channel' END AS channel_risk_tag
FROM sales
GROUP BY Payment_Mode 
ORDER BY SUM(CASE WHEN Order_Status = 'Delivered' THEN Total_Amount ELSE 0 END) DESC;

### Q5. Repeat customers and loyalty tiers

```sql
SELECT Customer_ID, 
       FORMAT(COUNT(Order_ID), 0) AS total_delivered_orders,
       FORMAT(SUM(Total_Amount), 2) AS lifetime_spend,
       FORMAT(AVG(Total_Amount), 2) AS avg_order_value,
       CASE WHEN SUM(Total_Amount) >= 50000 THEN 'VIP Patron'
            WHEN SUM(Total_Amount) >= 20000 THEN 'High-Value Customer'
            ELSE 'Standard Repeat Buyer' END AS loyalty_tier
FROM sales
WHERE Order_Status = 'Delivered'
GROUP BY Customer_ID
HAVING COUNT(Order_ID) > 1
ORDER BY SUM(Total_Amount) DESC;

## Key Findings

* **Revenue Performance:** Total delivered revenue is **₹4.74B**. **Electronics drives 72.6%** of it (₹3.44B), followed by Home (12.1%), Sports (8.0%), and Fashion (5.6%).
* **Underperforming Categories:** Grocery, Beauty, and Books together contribute only **1.7%** of revenue.
* **Return Concentration:** Electronics (3,351) and Fashion (2,496) account for **46.8%** of all returned orders.
* **Payment Gateway Distribution:** UPI processes **53.6%** of realized revenue, followed by COD (31.1%).
* **Channel Operational Risk:** Cancellation rates remain consistent across all payment modes (**4.9% to 5.1%**), categorizing every channel as **Healthy**.
* **VIP Customer Base:** **38,406 customers** placed more than one delivered order. The top repeat customers spend **₹740K to ₹890K** each, placing them in the **VIP Patron** tier.

---

## Business Recommendations

* **Portfolio Diversification:** Reduce revenue dependence on Electronics by scaling mid-tier categories like Home and Sports.
* **Category Audit:** Evaluate low-margin and low-revenue segments (Grocery, Beauty, Books) to optimize listing and inventory costs.
* **Reverse Logistics Reduction:** Investigate quality control, sizing, and packaging in Electronics and Fashion to curb high return volumes.
* **Retention Programs:** Implement targeted loyalty rewards and early-access campaigns for the VIP Patron customer cohort.

---

## Files

* `sales_analysis.sql.sql`: Contains all SQL queries for the project.

---

## Author

**Raj Varma**  
LinkedIn: [linkedin.com/in/raj-varma9326](https://www.linkedin.com/in/raj-varma9326)














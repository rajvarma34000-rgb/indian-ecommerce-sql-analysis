# Indian E-commerce SQL Analysis

**Problem:** Identify revenue drivers, cancellation losses, return patterns, payment-channel risk and high-value customers for an Indian e-commerce business.

## Database
**Schema:** `indian_ecommerce`
**Tables:** `customers`, `products`, `sales`
**Tool:** MySQL Workbench 8.0

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
![Q1](q1_delivered_revenue.png)

### Q2. Lost discount value from cancellations
![Q2](q2_lost_discount.png)

### Q3. Returned orders by category
![Q3](q3_returned_orders.png)

### Q4. Payment channel performance
![Q4](q4_gateway_performance.png)

### Q5. Repeat customers and loyalty tiers
![Q5](q5_repeat_customers.png)

## Key Findings

- Total delivered revenue is **₹4.74B**. **Electronics drives 72.6%** of it (₹3.44B), followed by Home (12.1%), Sports (8.0%) and Fashion (5.6%).
- Grocery, Beauty and Books together contribute only **1.7%** of revenue.
- Electronics (3,351) and Fashion (2,496) account for **46.8%** of all returned orders.
- UPI processes **53.6%** of realized revenue, followed by COD (31.1%).
- Cancellation rates are almost the same across all payment modes (**4.9% to 5.1%**), so every channel is tagged "Healthy".
- **38,406 customers** placed more than one delivered order. The top repeat customers spend ₹740K to ₹890K each and are all VIP Patrons.

## Business Recommendations

- Reduce dependence on Electronics by growing Home and Sports.
- Review the low-revenue categories (Grocery, Beauty, Books).
- Investigate Electronics and Fashion returns.
- Run loyalty rewards for the VIP segment.

## Files
- `sales_analysis.sql`: all queries for the project

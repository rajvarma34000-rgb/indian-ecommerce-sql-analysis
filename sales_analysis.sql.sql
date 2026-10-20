-- PROJECT :- 
 
 -- Q1. Which product categories generate the highest delivered revenue, how many units do they sell, and how do they rank by business investment tier?

select p.category,
       FORMAT(SUM(s.quantity), 0) AS total_units_sold,
       FORMAT(SUM(s.total_amount), 2) AS delivered_revenue,
       CASE WHEN SUM(s.total_amount) >= 100000000 THEN 'Core Driver Tier'
            WHEN SUM(s.total_amount) >= 50000000  THEN 'Mid-Tier Performer'
            ELSE 'Underperforming Tier'
       END AS category_tier
from sales s
INNER JOIN products p ON s.Product_ID = p.Product_ID
WHERE s.Order_Status = 'Delivered'
group by p.category
order by SUM(s.total_amount) desc;

-- Q2. Which product categories lose the highest coupon discount value due to cancelled orders?

SELECT 
    p.Category,
    FORMAT(SUM(s.Coupon_Discount), 2) AS lost_discount_value
FROM sales s
INNER JOIN products p ON s.Product_ID = p.Product_ID
WHERE s.Order_Status = 'Cancelled'
GROUP BY p.Category
ORDER BY SUM(s.Coupon_Discount) DESC;

-- Q3. Which product categories experience the highest volume of returned orders?

SELECT 
    p.category, 
    FORMAT(COUNT(s.Order_ID), 0) AS returned_orders_count
FROM sales s
INNER JOIN products p ON s.Product_ID = p.Product_ID
WHERE s.Order_Status = 'Returned'
GROUP BY p.Category
ORDER BY COUNT(s.Order_ID) DESC;

-- Q4. Which payment channels process the highest realized revenue, and how do their cancellation rates rank by operational risk?

Select Payment_Mode,
    FORMAT(count(order_ID), 0) AS total_orders,
    FORMAT(count(Case When Order_Status = 'Delivered' Then 1 End), 0) AS delivered_orders,
    FORMAT(count(Case When Order_Status = 'Cancelled' Then 1 End), 0) AS cancelled_orders,
    FORMAT(SUM(Case When Order_status = 'Delivered' Then Total_Amount Else 0 End), 2) AS realized_revenue,
    round(sum(Case When Order_Status = 'Cancelled' Then 1 End) / Count(Order_ID) * 100, 2) AS cancellation_rate_pct,
Case When (count(Case When Order_Status = 'Cancelled' Then 1 End) / count(Order_ID)) * 100 > 20 Then 'High Risk Channel'        
     When (count(Case When Order_Status = 'Cancelled' Then 1 end) / Count(Order_ID)) * 100 >= 10 Then 'Moderate Risk Channel'
     Else 'Healthy Channel' End AS channel_risk_tag
From Sales
group by Payment_Mode 
order by SUM(Case When Order_status = 'Delivered' Then Total_Amount Else 0 End) desc;
     
-- Q5. Who are our repeat customers (delivered orders > 1), how much lifetime revenue do they generate, and what loyalty tier do they belong to?     
     
SELECT Customer_ID, 
       FORMAT(Count(Order_ID), 0) AS total_delivered_orders,
       FORMAT(SUM(Total_Amount), 2) AS lifetime_spend,
       FORMAT(AVG(Total_Amount), 2) AS avg_order_value,
CASE WHEN SUM(Total_Amount) >= 50000 THEN 'VIP Patron'
     WHEN SUM(Total_Amount) >= 20000 THEN 'High-Value Customer'
     ELSE 'Standard Repeat Buyer'
     END AS loyalty_tier
FROM sales
WHERE Order_Status = 'Delivered'
GROUP BY Customer_ID
HAVING COUNT(Order_ID) > 1
ORDER BY SUM(Total_Amount) DESC;
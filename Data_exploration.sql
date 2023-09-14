SELECT * FROM orders
SELECT * FROM customers
-- 1. KPIs for Total Revenue, # number of orders, profit margin:
SELECT SUM(revenue) AS total_revenue,
		SUM(profit) AS total_profit,
		COUNT(*) AS total_orders,
		SUM(profit)/SUM(revenue) * 100 AS profit_margin
FROM orders

-- 2. Total Revenue, # number of orders, profit margin for each sport
SELECT sport,
		ROUND(SUM(revenue),2) AS total_revenue,
		ROUND(SUM(profit),2) AS total_profit,
		COUNT(*) AS total_orders,
		SUM(profit)/SUM(revenue) * 100 AS profit_margin
FROM orders
GROUP BY sport
ORDER BY profit_margin DESC

SELECT DISTINCT sport, COUNT(*)
FROM orders
GROUP BY sport

DELETE FROM orders
WHERE sport = ' '

-- 3. Number of customer ratings and the average rating
SELECT (SELECT COUNT(*)
FROM orders
WHERE rating IS NOT NULL) AS number_of_reviews,
ROUND(AVG(rating), 2) AS average_rating
FROM orders

-- 4. Number of people for each rating and its revenue, profit margin
SELECT rating,
		SUM(revenue) AS total_revenue,
		SUM(profit) AS total_profit,
		SUM(profit)/SUM(revenue) * 100 AS profit_margin
FROM orders
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY rating DESC


-- 5. State revenue, profit, and profit margin:
SELECT c.state,
		ROW_NUMBER() OVER (ORDER BY SUM(o.revenue) DESC) AS revenue_rank,
		SUM(o.revenue) AS total_revenue,
		ROW_NUMBER() OVER (ORDER BY SUM(o.profit) DESC) AS profit_rank,
		SUM(o.profit) AS total_profit,
		ROW_NUMBER() OVER (ORDER BY SUM(o.profit)/SUM(o.revenue) DESC) AS profit_margin_rank,
		SUM(o.profit)/SUM(o.revenue) * 100 AS profit_margin
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.state
ORDER BY profit_margin_rank 

-- 6. Monthly Profits:
WITH monthly_profit AS (SELECT MONTH(date) AS month,
	SUM(profit) AS total_profit
FROM orders
GROUP BY MONTH(date) )

SELECT month, total_profit,
	LAG(Total_profit) OVER (ORDER BY month) AS prev_month_profit,
	total_profit - LAG(Total_profit) OVER (ORDER BY month) AS profit_difference
FROM monthly_profit
ORDER BY month




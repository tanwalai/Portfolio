/*In this script, I quiried the data in the restaurant database to find insight to improve sales.*/

-- Q1 : Top 5 best seller menu
SELECT 
	A.menu_name,
	count(B.menu_id) AS Sales
FROM Order_Menu AS 'B'
LEFT JOIN Menu AS 'A'
ON A.menu_id = B.menu_id
GROUP BY B.menu_id
ORDER BY count(B.menu_id) DESC 
LIMIT 5;

-- Q2 : The golden hour of our restaurant
SELECT	
	strftime('%H', order_date) AS 'Hours',
	sum(total_price) AS 'revenue'
FROM Orders 
GROUP BY strftime('%H', order_date)
ORDER BY revenue DESC;

-- Q3 : Find location for new branch
SELECT 
	A.location_name,
	count(B.order_id) AS 'number_orders',
	sum(B.total_price) AS 'revenue'
FROM Location AS 'A', Orders AS 'B'
WHERE A.location_id = B.location_id 
GROUP BY A.location_name
ORDER BY revenue DESC ;

-- Q4 : Customer purchasing patterns (market basket analysis)
/*Looking for a menu that customers frequently purchase together. */
SELECT 
	Order1.menu_id,
	Order2.menu_id,
	count(*) AS 'Quantity'
FROM Order_Menu AS 'Order1' , Order_Menu AS 'Order2' 
WHERE Order1.order_id = Order2.order_id 
AND Order1.menu_id != Order2.menu_id
AND Order1.menu_id < Order2.menu_id
GROUP BY Order1.menu_id, Order2.menu_id
HAVING count(*) > 1
ORDER BY count(*) DESC ; 
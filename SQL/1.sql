-- Source: https://www.youtube.com/watch?v=0dCqt4jpMCs&ab_channel=NishthaNagar

-- Script:
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    item VARCHAR(255) NOT NULL
);

INSERT INTO orders (order_id, item) VALUES
(1, 'Chow Mein'),
(2, 'Pizza'),
(3, 'Veg Nuggets'),
(4, 'Paneer Butter Masala'),
(5, 'Spring Rolls'),
(6, 'Veg Burger'),
(7, 'Paneer Tikka');

-- Solution 1:

SELECT
	OrderID = 
		CASE WHEN order_id <> (SELECT COUNT(*) FROM orders)
			THEN
				CASE 
					WHEN order_id % 2 = 0 THEN order_id -1
					WHEN order_id % 2 = 1 THEN order_id + 1
				END
			ELSE order_id
		END,
	Item
FROM Orders
ORDER BY OrderID

-- Solution 2

SELECT OrderID = order_id,
	Item = CASE 
		WHEN order_id = (SELECT COUNT(*) FROM orders) THEN item
		ELSE
			CASE 
				WHEN O.mod = 0 THEN LAG(item, 1) OVER(ORDER BY order_id) 
				WHEN O.mod = 1 THEN LEAD(item, 1) OVER(ORDER BY order_id) 
			END
	END
FROM (
	SELECT *, mod = order_id % 2 
	FROM orders
) AS O

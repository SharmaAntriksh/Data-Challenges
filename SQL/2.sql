-- Source: https://www.youtube.com/watch?v=gKSs5yIvTgs&ab_channel=NishthaNagar

-- Script:
CREATE TABLE transactions (
    product_id INT,
    user_id INT,
    spend DECIMAL(10, 2),
    transaction_date DATETIME
);

INSERT INTO transactions (product_id, user_id, spend, transaction_date)
VALUES
(3673, 123, 68.90, '2022-07-08 10:00:00'),
(9623, 123, 274.10, '2022-07-08 10:00:00'),
(1467, 115, 19.90, '2022-07-08 10:00:00'),
(2513, 159, 25.00, '2022-07-08 10:00:00'),
(1452, 159, 74.50, '2022-07-10 10:00:00'),
(1452, 123, 74.50, '2022-07-10 10:00:00'),
(9765, 123, 100.15, '2022-07-11 10:00:00'),
(6536, 115, 57.00, '2022-07-12 10:00:00'),
(7384, 159, 15.50, '2022-07-12 10:00:00'),
(1247, 159, 23.40, '2022-07-12 10:00:00');  

-- Solution 1:

SELECT  transaction_date, user_id, purchase_count = COUNT(*) 
FROM (
	SELECT *, TransactionDateRank = RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC)
	FROM Transactions
) AS T
WHERE T.TransactionDateRank = 1
GROUP BY  user_id, transaction_date


-- Solution 2: 
;WITH UserLastTransactionDate AS (
	SELECT user_id, LastTransaction = MAX(transaction_date) 
	FROM Transactions
	GROUP BY user_id
),
LastTransactionDateRows AS (
	SELECT T.* 
	FROM Transactions AS T
	INNER JOIN UserLastTransactionDate AS ULT
			ON T.user_id = ULT.user_id AND 
				T.transaction_date = ULT.LastTransaction
)

SELECT transaction_date, user_id, purchase_count = COUNT(*) 
FROM LastTransactionDateRows
GROUP BY transaction_date, user_id
ORDER BY transaction_date ASC
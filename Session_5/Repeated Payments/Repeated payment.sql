SELECT 
       COUNT(distinct t1.transaction_id) AS payment_count
FROM transactions as t 
JOIN transactions as t1
ON t.merchant_id = t1.merchant_id
AND t.amount = t1.amount
AND t.credit_card_id = t1.credit_card_id
AND t1.transaction_timestamp > t.transaction_timestamp
AND t1.transaction_timestamp <= t.transaction_timestamp + INTERVAL '10 minutes'

;

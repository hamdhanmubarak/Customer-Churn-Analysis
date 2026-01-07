-- ANALYSIS --
-- Find Financial Churn (who stopped paying) (last payment date for each customer)

select customer_id,
    max (transaction_date) as last_payment_date
from transactions
group by customer_id;

-- filter out these customers who haven't made a payment in the last 90 days

SELECT customer_id,
MAX(transaction_date) as last_payment_date
FROM transactions
GROUP BY customer_id
HAVING MAX(transaction_date) < DATE '2025-03-09' - INTERVAL '90 days';

-- Finding Engagement Churn (who stopped logging in)

SELECT customer_id,
MAX (event_date) as last_login_date
FROM user_activity
WHERE event_type = 'Login'
group by customer_id;

-- filter users who haven't logged in 90+ days

SELECT customer_id,
MAX (event_date) as last_login_date
FROM user_activity
WHERE event_type = 'Login'
group by customer_id
HAVING MAX(event_date) < DATE '2025-03-09' - INTERVAL '90 days';

-- silent churns folks (who pays but not logged in)
select t.customer_id,
MAX(t.transaction_date) as last_payment_date,
MAX (event_date) as last_login_date
from transactions t
left join user_activity ua on t.customer_id = ua.customer_id
group by t.customer_id;

-- filter by those who pay but still not login

select t.customer_id,
MAX(t.transaction_date) as last_payment_date,
MAX (event_date) as last_login_date
from transactions t
left join user_activity ua on t.customer_id = ua.customer_id
group by t.customer_id
HAVING MAX(t.transaction_date) <= DATE '2025-03-09' - INTERVAL '90 days'
AND MAX(ua.event_date) < DATE '2025-03-09' - INTERVAL '90 days';

-- COMBINE EVERYTHING --

WITH churn_data AS (
    SELECT
        c.customer_id,
        c.name,
        c.email,
        fc.customer_id AS financial_churn_flag
    FROM customers c
    LEFT JOIN (
        SELECT customer_id
        FROM transactions
        GROUP BY customer_id
        HAVING MAX(transaction_date) < DATE '2025-03-09' - INTERVAL '90 days'
    ) fc
        ON c.customer_id = fc.customer_id
)
SELECT *
FROM churn_data;

-- Engagement churn

WITH churn_data AS (
    SELECT
        c.customer_id,
        c.name,
        c.email,
        fc.customer_id AS financial_churn_flag,
		ec.customer_id AS engagement_churn_flag
    FROM customers c
    LEFT JOIN (
        SELECT customer_id
        FROM transactions
        GROUP BY customer_id
        HAVING MAX(transaction_date) < DATE '2025-03-09' - INTERVAL '90 days') fc
        ON c.customer_id = fc.customer_id
		left join (
		select customer_id
		from user_activity
		where event_type = 'login'
		group by customer_id
		having max (event_date) < DATE '2025-03-09' - INTERVAL '90 days') as ec
		on c.customer_id = ec.customer_id
)
SELECT *
FROM churn_data;




WITH churn_data AS (
    SELECT
        c.customer_id,
        c.name,
        c.email,
		CASE
		WHEN fc.customer_id IS NOT NULL THEN 'financial_churn'
        WHEN ec.customer_id IS NOT NULL THEN 'engagement_churn'
		WHEN sc.customer_id IS NOT NULL THEN 'silent_churn'
		ELSE 'active'
		END AS churn_type
    FROM customers c
    LEFT JOIN (
        SELECT customer_id
        FROM transactions
        GROUP BY customer_id
        HAVING MAX(transaction_date) < DATE '2025-03-09' - INTERVAL '90 days') fc
        ON c.customer_id = fc.customer_id
    LEFT JOIN (
        SELECT customer_id
        FROM user_activity
        WHERE event_type = 'Login'
        GROUP BY customer_id
        HAVING MAX(event_date) < DATE '2025-03-09' - INTERVAL '90 days') ec
        ON c.customer_id = ec.customer_id
	left join (
		select t.customer_id
		from transactions t
		left join user_activity ua
		on t.customer_id = ua.customer_id
		group by t.customer_id
		HAVING MAX(t.transaction_date) >= DATE '2025-03-09' - INTERVAL '90 days'
		and MAX(ua.event_date) < DATE '2025-03-09' - INTERVAL '90 days') sc
		on c.customer_id = sc.customer_id
)
SELECT *
FROM churn_data;
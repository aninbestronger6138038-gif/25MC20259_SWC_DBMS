WITH monthly_users AS (
    SELECT DISTINCT
           user_id,
           DATE_TRUNC('month', event_date) AS month_start
    FROM user_actions
)

SELECT
    EXTRACT(MONTH FROM current.month_start) AS month,
    COUNT(DISTINCT current.user_id) AS monthly_active_users
FROM monthly_users current
JOIN monthly_users prev
    ON current.user_id = prev.user_id
   AND current.month_start >= prev.month_start + INTERVAL '1 month'
GROUP BY 1
ORDER BY month desc
;

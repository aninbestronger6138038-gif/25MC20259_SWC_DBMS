SELECT
    u.user_segment,

    COUNT(*) AS total_searches,

    SUM(
        CASE
            WHEN (
                SELECT MIN(c.event_timestamp)
                FROM search_events c
                WHERE c.session_id = s.session_id
                  AND c.event_type='click'
                  AND c.event_timestamp > s.event_timestamp
            )
            <= s.event_timestamp + INTERVAL '30 seconds'

            THEN 1
            ELSE 0
        END
    ) AS successful_searches,

    ROUND(
        SUM(
            CASE
                WHEN (
                    SELECT MIN(c.event_timestamp)
                    FROM search_events c
                    WHERE c.session_id = s.session_id
                      AND c.event_type='click'
                      AND c.event_timestamp > s.event_timestamp
                )
                <= s.event_timestamp + INTERVAL '30 seconds'

                THEN 1
                ELSE 0
            END
        )::numeric
        / COUNT(*),
        2
    ) AS success_rate

FROM search_events s

JOIN
(
    SELECT
        a.user_id,
        CASE
            WHEN a.registration_date >=
                 (
                  SELECT MAX(event_timestamp)::date
                  FROM search_events
                 ) - INTERVAL '30 days'
            THEN 'new'
            ELSE 'existing'
        END AS user_segment
    FROM accounts a
) u

ON s.user_id = u.user_id

WHERE s.event_type='search'

GROUP BY u.user_segment;

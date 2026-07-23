-- Динамика средней продолжительности игровой сессии по месяцам (длительностью более 5 минут)
SELECT DATE_TRUNC('month', session_start_time)::date AS session_month
     , ROUND(EXTRACT(EPOCH FROM AVG(session_end_time - session_start_time)) / 60
            ) AS avg_session_duration_min
FROM planet_hunt.player_activity_log
WHERE session_end_time - session_start_time > INTERVAL '5 minutes'
GROUP BY session_month
ORDER BY session_month
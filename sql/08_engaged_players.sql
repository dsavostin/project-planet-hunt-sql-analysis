/*
Анализ наиболее вовлечённых пользователей

Бизнес-вопрос:
Какие пользователи проводят больше всего времени в игре?
Необходимо выделить наиболее активных пользователей за 2025 год для дальнейших маркетинговых активностей.
*/


SELECT pa.player_id
     , SUM(EXTRACT(EPOCH FROM 
          (pa.session_end_time - pa.session_start_time)) / 60) AS total_minutes
FROM planet_hunt.player_activity_log AS pa
LEFT JOIN planet_hunt.players_profile AS pp
     ON pa.player_id = pp.player_id
WHERE pa.session_end_time IS NOT NULL
      AND pp.registration_date >= '2025-01-01'
      AND pp.registration_date < '2026-01-01'
GROUP BY pa.player_id
ORDER BY total_minutes DESC
LIMIT 25
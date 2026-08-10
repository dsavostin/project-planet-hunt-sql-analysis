-- Сравнение средней длительности игровых сессий
-- для когорты ноября-декабря 2025 года и остальных пользователей

SELECT CASE WHEN DATE_TRUNC('month', pp.registration_date) IN ('2025-11-01', '2025-12-01') THEN '11-12.2025' ELSE 'Другие месяцы' END AS cohorts
      , AVG(pal.session_end_time - pal.session_start_time) AS avg_session_time
FROM planet_hunt.players_profile AS pp
LEFT JOIN planet_hunt.player_activity_log AS pal
    ON pp.player_id = pal.player_id
WHERE pal.session_end_time - pal.session_start_time > INTERVAL '5 minute'
GROUP BY cohorts

/*
Вывод:

Игроки, зарегистрированные в ноябре и декабре 2025 года,
проводят в игре в среднем больше времени, чем пользователи
остальных когорт.

Гипотеза о более высокой лояльности аудитории,
привлечённой в период тестирования новой маркетинговой
стратегии, подтверждается.
*/
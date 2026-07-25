/*
Расчёт продуктовых метрик активности пользователей

Бизнес-вопрос:
Как менялась активность пользователей игры во времени?
Необходимо рассчитать DAU, WAU и MAU для оценки вовлечённости пользователей.
*/


-- DAU: количество уникальных пользователей за день

SELECT DATE_TRUNC('day', session_start_time) AS day
     , COUNT(DISTINCT player_id) AS dau
FROM planet_hunt.player_activity_log
GROUP BY day
ORDER BY day


-- WAU: количество уникальных пользователей за неделю

SELECT DATE_TRUNC('week', session_start_time) AS week
     , COUNT(DISTINCT player_id) AS wau
FROM planet_hunt.player_activity_log
GROUP BY week
ORDER BY week


-- MAU: количество уникальных пользователей за месяц

SELECT DATE_TRUNC('month', session_start_time) AS month
     , COUNT(DISTINCT player_id) AS mau
FROM planet_hunt.player_activity_log
GROUP BY month
ORDER BY month
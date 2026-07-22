/*
Динамика регистраций пользователей

Задача:
Определить изменение размера пользовательской базы
и найти месяцы с максимальным приростом новых пользователей.
*/

SELECT DATE_TRUNC('month', registration_date)::date AS reg_month
     , COUNT(*) AS new_users
FROM planet_hunt.players_profile
GROUP BY reg_month
ORDER BY reg_month



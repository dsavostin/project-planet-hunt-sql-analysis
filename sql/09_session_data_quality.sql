/*
Проверка качества данных игровых сессий

Задача:
Оценить масштаб проблемы с отсутствием времени окончания сессии.
*/

-- Количество записей без времени окончания сессии

SELECT COUNT(*) AS cnt_null_ses
FROM planet_hunt.player_activity_log
WHERE session_end_time IS NULL

-- Доля записей без времени окончания сессии среди всех сессий

SELECT SUM(
           CASE
               WHEN session_end_time IS NULL THEN 1.0
               ELSE 0.0
           END
          ) / COUNT(*) AS share_null_ses
FROM planet_hunt.player_activity_log

-- Доля записей без времени окончания сессии по типам устройств

SELECT pp.platform_type
     , SUM(
           CASE
               WHEN session_end_time IS NULL THEN 1.0
               ELSE 0.0
           END
          ) / COUNT(*) AS share_null_ses
FROM planet_hunt.player_activity_log AS pal
LEFT JOIN planet_hunt.players_profile AS pp
       ON pal.player_id = pp.player_id
GROUP BY pp.platform_type

-- Распределение проблемных записей между iOS и Android

SELECT SUM(
           CASE
               WHEN pp.platform_type = 'ios' THEN 1.0
               ELSE 0.0
           END
          ) / COUNT(*) * 100 AS share_null_ios
     , SUM(
           CASE
               WHEN pp.platform_type = 'android' THEN 1.0
               ELSE 0.0
           END
          ) / COUNT(*) * 100 AS share_null_android
FROM planet_hunt.player_activity_log AS pal
LEFT JOIN planet_hunt.players_profile AS pp
       ON pal.player_id = pp.player_id
WHERE pal.session_end_time IS NULL;

/*
Вывод:
- Обнаружены игровые сессии без времени окончания.
- Большая часть проблемных записей приходится на устройства iOS.
*/
/*
Определение валидных игровых сессий.

В рамках исследования валидной считается сессия длительностью более 5 минут.
*/

SELECT COUNT(*) AS cnt_sessions
     , SUM(CASE WHEN session_end_time - session_start_time > INTERVAL '5 minutes' 
                THEN 1 
                ELSE 0 
           END
          ) AS cnt_valid_sessions
     , ROUND(SUM(CASE WHEN session_end_time - session_start_time > INTERVAL '5 minutes' 
                      THEN 1 
                      ELSE 0 
                 END
                ) / COUNT(*)::float * 100) AS share_valid_sessions
FROM planet_hunt.player_activity_log

/*
Вывод:
71% игровых сессий являются валидными.

Для дальнейшего анализа используются только валидные игровые сессии длительностью более 5 минут.
*/
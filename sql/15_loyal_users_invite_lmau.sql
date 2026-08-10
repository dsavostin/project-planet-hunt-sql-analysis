-- Динамика LMAU пользователей, активно участвующих в реферальной программе
-- В лояльный сегмент входят игроки, которые отправили не менее трёх приглашений и привели хотя бы одного зарегистрированного пользователя

WITH crit_invite as 
(select player_id
	  , COUNT(*) AS cnt_invite
	  , SUM(friend_reg_flag) AS cnt_reg
FROM planet_hunt.invite_network
GROUP BY player_id
HAVING COUNT(*) >= 3
   AND SUM(friend_reg_flag) >= 1)
   
SELECT DATE_TRUNC('month', session_start_time )::date AS mm
     , COUNT(DISTINCT player_id) AS lmau
FROM planet_hunt.player_activity_log pal
WHERE player_id IN (SELECT player_id FROM crit_invite)
GROUP BY mm

-- Размер сегмента реферальных пользователей постепенно увеличивается на протяжении периода наблюдения.
-- Реферальная программа формирует отдельную группу игроков, участвующих в органическом росте пользовательской базы.


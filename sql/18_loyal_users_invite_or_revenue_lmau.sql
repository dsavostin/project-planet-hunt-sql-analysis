-- Динамика LMAU пользователей, удовлетворяющих хотя бы одному из критериев ценности
-- В сегмент включаются активные рефереры и платящие игроки

WITH crit_invite AS
(SELECT player_id
	  , COUNT(*) AS cnt_invite
	  , SUM(friend_reg_flag) AS cnt_reg
FROM invite_network
GROUP BY player_id
HAVING COUNT(*) >= 3
   AND SUM(friend_reg_flag) >= 1
)
,

crit_1000 AS
(SELECT player_id
	  , SUM(purchase_quantity * asset_price) AS revenue
FROM purchase_events AS pe
INNER JOIN item_price_history AS lp
		ON pe.asset_id = lp.asset_id
	   AND purchase_datetime >= price_period_start
	   AND purchase_datetime < COALESCE(price_period_end,'3000-01-01')
GROUP BY player_id
HAVING SUM(purchase_quantity * asset_price) >= 1000
)

SELECT DATE_TRUNC('month'  ,session_start_time)::date AS mm
	 , COUNT(DISTINCT player_id) AS LWAU
FROM player_activity_log
WHERE player_id IN (SELECT player_id FROM crit_1000)
				OR player_id IN (SELECT player_id FROM crit_invite)
GROUP BY mm

-- Объединённый сегмент охватывает наиболее значимую часть активной аудитории.
-- Метрика позволяет отслеживать изменение объёма ценных пользователей во времени.
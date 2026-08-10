-- Динамика LMAU пользователей с суммарными платежами от 1000 рублей
-- Анализируется активность наиболее монетизируемой части аудитории

WITH crit_1000 as
(SELECT player_id
      , SUM(purchase_quantity * asset_price) AS revenue
FROM purchase_events m
INNER JOIN item_price_history lp
	    ON m.asset_id = lp.asset_id
       AND purchase_datetime >= price_period_start
       AND purchase_datetime < COALESCE(price_period_end,'3000-01-01')
GROUP BY player_id
HAVING SUM(purchase_quantity * asset_price) >= 1000
)

SELECT DATE_TRUNC('month',session_start_time) AS mm
     , COUNT(DISTINCT player_id) AS LMAU
FROM player_activity_log
WHERE player_id IN (SELECT player_id FROM crit_1000)
GROUP BY mm

-- Сегмент платящих пользователей существенно меньше общей аудитории.
-- Несмотря на это, данная группа формирует основную часть игровой выручки
-- Динамика LMAU пользователей, одновременно участвующих в реферальной программе и совершивших платежи от 1000 рублей
-- Исследуется пересечение наиболее вовлечённой и наиболее прибыльной аудитории

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
FROM purchase_events m
INNER JOIN item_price_history lp
        ON m.asset_id = lp.asset_id
       AND purchase_datetime >= price_period_start
       AND purchase_datetime < COALESCE(price_period_end,'3000-01-01')
GROUP BY player_id
HAVING SUM(purchase_quantity * asset_price) >= 1000
)

 SELECT DATE_TRUNC('month'  ,session_start_time) AS mm
      , COUNT(DISTINCT player_id) AS LWAU
 FROM player_activity_log
 WHERE player_id IN (SELECT player_id FROM crit_1000)
   AND player_id IN (SELECT player_id FROM crit_invite)
GROUP BY mm

-- Размер сегмента существенно ниже отдельных групп по каждому критерию.
-- Данная аудитория представляет наибольшую ценность для продукта и маркетинга.
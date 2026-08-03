/*
Когортный анализ выручки.

Рассчитать среднюю выручку на одного пользователя
за один месяц жизни для каждой когорты регистрации.

В качестве окончания lifetime когорты использовать
дату последней транзакции в исследуемом периоде.

Определить когорты с наиболее высоким уровнем монетизации.
*/
 
WITH max_date AS (
	SELECT max(purchase_datetime)::date AS max_date
	FROM planet_hunt.purchase_events
	),

cohort_revenue AS (
	SELECT
	      date_trunc('month', pp.registration_date)::date AS cohort
	    , sum(pe.purchase_quantity * iph.asset_price) AS revenue
	    , count(DISTINCT pe.player_id) AS cohort_amount
	    , sum(pe.purchase_quantity * iph.asset_price) / count(DISTINCT pe.player_id) AS arppu
	FROM planet_hunt.purchase_events AS pe
	JOIN planet_hunt.item_price_history AS iph
	    ON pe.asset_id = iph.asset_id
	   AND pe.purchase_datetime >= iph.price_period_start
	   AND pe.purchase_datetime < coalesce(iph.price_period_end, '3000-01-01')
	JOIN planet_hunt.players_profile AS pp
	    ON pe.player_id = pp.player_id
	GROUP BY cohort
	)

SELECT cr.*
     , md.max_date
     , round((md.max_date - cr.cohort) / 30.0, 2) AS lifetime
     , round(cr.arppu / round((md.max_date - cr.cohort) / 30.0, 2), 2) AS arppu_per_month
FROM cohort_revenue as cr
CROSS JOIN max_date as md
ORDER BY cr.cohort
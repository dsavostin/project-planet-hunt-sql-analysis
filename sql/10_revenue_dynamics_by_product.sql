/* 
Задача

Проанализировать динамику выручки по месяцам
в разрезе игровых продуктов.

Для расчёта выручки используется цена,
которая была актуальна на момент покупки.
*/

select 
	   date_trunc('month', pe.purchase_datetime)::date as mm
	 , gac.asset_category
	 , sum(pe.purchase_quantity * iph.asset_price) as revenue
from planet_hunt.purchase_events as pe
join planet_hunt.item_price_history as iph
    on pe.asset_id = iph.asset_id
   and pe.purchase_datetime >= iph.price_period_start
   and pe.purchase_datetime < coalesce(price_period_end, '3000-01-01') 
join planet_hunt.game_assets_catalog as gac 
    on pe.asset_id = gac.asset_id 
group by
      mm
    , gac.asset_category
order by
      mm
    , gac.asset_category
    
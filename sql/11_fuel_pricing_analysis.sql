/*С 1 января 2026 года в игре была увеличена стоимость топлива. 
 Необходимо оценить реакцию игроков на изменение цены.
 
 Необходимо проверить:

- как изменилась средняя покупка топлива после повышения цены;
- как изменение цены повлияло на месячную выручку;
- удалось ли компенсировать снижение объёма покупок ростом цены.
 */

select
 	   date_trunc('month', pe.purchase_datetime)::date as mm
 	 , round(avg(pe.purchase_quantity), 2) as avg_cnt
	 , sum(pe.purchase_quantity * iph.asset_price) as revenue
from planet_hunt.purchase_events as pe
join planet_hunt.item_price_history as iph
    on pe.asset_id = iph.asset_id
   and pe.purchase_datetime >= iph.price_period_start
   and pe.purchase_datetime < coalesce(price_period_end, '3000-01-01') 
join planet_hunt.game_assets_catalog as gac 
    on pe.asset_id = gac.asset_id 
where gac.asset_name = 'Fuel'
group by mm
order by mm
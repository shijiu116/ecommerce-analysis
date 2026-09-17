with funnel as(
    select 
     count(distinct case when event_type='view' then user_id end) as 浏览人数,
     count(distinct case when event_type='purchase' then user_id end)  as 购买人数,
     count(distinct case when event_type='purchase' and user_id not in (select user_id from userbehavior where event_type='cart') then user_id end) 
     as 浏览到购买人数,
     count(distinct case when event_type='cart' then user_id end) as 加购人数,
     count(distinct case when event_type='cart' and user_id in (select user_id from userbehavior where event_type='purchase' ) then user_id end)
     as 既加购又购买人数
     from userbehavior
     )

select 
     浏览人数,
     购买人数,
     浏览到购买人数,
     加购人数,
     既加购又购买人数,
    concat(round(加购人数/浏览人数*100,2),'%') as 浏览转加购转化率,
    concat(round(浏览到购买人数/浏览人数*100,2),'%') as 浏览转购买转化率,
    concat(round(既加购又购买人数/加购人数*100,2),'%') as 加购转购买转化率,
    concat(round(购买人数/浏览人数*100,2),'%') as 总转化率
from funnel
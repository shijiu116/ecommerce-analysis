select 
    brand as 品牌名,
    count(*) as 购买数量,
    rank() over(order by count(brand) desc) as 排名
from userbehavior
where brand != 'unknown' and event_type='purchase'
group by brand
order by count(*) desc
limit 20；

select 
    brand as 品牌名,
    sum(price) as 销售额,
    rank() over(order by sum(price) desc) as 排名
from userbehavior
where brand != 'unknown' and event_type='purchase'
group by brand
order by  sum(price) desc
limit 20；
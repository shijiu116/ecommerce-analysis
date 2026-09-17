SELECT
    count(distinct user_id)        as 总用户数,
    count(distinct product_id)     as 总商品数,
    count(distinct category_id)    as 总类目数,
    count(distinct brand)-1        as 总品牌数,
    count(*)  as 总行为数,
    sum(case when event_type='view'  then 1 else 0 end) as 浏览次数,
    sum(case when event_type='cart'  then 1 else 0 end) as 加购次数,
    sum(case when event_type='purchase'  then 1 else 0 end) as 购买次数
from userbehavior;
with rfm_base as(
     select 
        user_id,
        DATEDIFF((select max(event_time) from userbehavior),max(event_time))  as recency,
        count(distinct event_time) as frequency,
        sum(price)   as monetary
        from userbehavior
        where event_type='purchase'
        group by user_id
),

rfm_score as(
     SELECT
     user_id,
       recency,
       frequency,
       monetary,
       ntile(4) over(order by recency asc) as r_score,
       ntile(4) over(order by frequency desc) as f_score,
       ntile(4) over(order by monetary desc) as m_score
       from rfm_base
     ),
rfm_segment as(
    SELECT
        user_id,
        recency,
        frequency,
        monetary,
        r_score,
        f_score,
        m_score,
        CASE 
            when r_score>=3 and f_score>=3 and m_score>=3 then '高价值用户'
            when r_score>=3 and f_score<3 then '新客/潜力用户'
            when r_score<3 and f_score<3 then  '流失预警客户'
            else '一般/流失用户'
        end as user_segment
      from rfm_score
)
select 
    user_segment as 用户品类,
    count(*) as 用户数量,
    concat(round(count(*)/(select count(*) from rfm_segment)*100,2),'%') as 所占百分比
from rfm_segment
group by user_segment
order by 用户数量 desc; 
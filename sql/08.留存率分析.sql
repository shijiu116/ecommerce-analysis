with daily_active as(
    select 
    distinct user_id, 
    date(event_time) as active_time
    from userbehavior
    where event_type='view'
),
first_day as(
    select 
    user_id,
    min(date(event_time)) as first_time
    from userbehavior
    where event_type='view'
    group by user_id
)
select 
    count(f.user_id) as 首次活跃的人数,
    count(case when datediff(d.active_time,f.first_time)=1 then 1 end) as 第二天上线的人数,
    count(case when datediff(d.active_time,f.first_time)=7 then 1 end) as 第七天上线的人数,
    concat(round(count(case when datediff(d.active_time,f.first_time)=1 then 1 end)/count(f.user_id)*100,2),'%')  as 次日留存率,
    concat(round(count(case when datediff(d.active_time,f.first_time)=7 then 1 end)/count(f.user_id)*100,2),'%')  as 七日留存率
from daily_active d
join first_day f
on d.user_id=f.user_id
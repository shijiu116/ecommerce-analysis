create table userbahavior_raw(
      event_time varchar(255),
      event_type varchar(255),
      product_id varchar(255),
      category_id varchar(255),
      category_code varchar(255),
      brand   varchar(255),
      price   varchar(255),
      user_id varchar(255),
      user_session varchar(255)
      )
      
select count(*) from userbahavior_raw;

create table userbehavior(
      event_time datetime,
      event_type varchar(50),
      product_id bigint,
      category_id bigint,
      category_code varchar(100),
      brand   varchar(100),
      price   decimal(10,2),
      user_id bigint,
      user_session varchar(255)
      )
      
delete from userbahavior_raw where event_time='event_time'
INSERT INTO userbehavior
SELECT 
    STR_TO_DATE(event_time,'%Y-%m-%d %H:%i:%s'),
    event_type,
    product_id + 0,
    category_id + 0,
    category_code,
    brand,
    price + 0,
    user_id + 0,
    user_session
FROM userbahavior_raw;
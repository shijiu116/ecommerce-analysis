delete from userbehavior where event_time is null or user_id is null or product_id is null;

SELECT
event_time,
event_type,
product_id,
category_id,
IF(category_code = '' OR category_code IS NULL, 'unknown', category_code) AS category_code,
IF(brand = '' OR brand IS NULL, 'unknown', brand) AS brand,
price,
user_id,
user_session
FROM userbehavior;

select count(*)-count(distinct concat(event_time,"-",user_id,"-",user_session)) as duplicate_rows from userbehavior

update userbehavior set 
category_code=IF(category_code = '' OR category_code IS NULL, 'unknown', category_code),
brand=IF(brand = '' OR brand IS NULL, 'unknown', brand);
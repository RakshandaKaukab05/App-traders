/*count total no of rows from app_store*/
select count(*) from app_store_apps;
/*count total no of rows from play_store*/
select count(*) from play_store_apps;
/*Select all columns from app store*/
select * from app_store_apps;
/*Select all columns from play store*/
select * from play_store_apps;
/*app store analysis*/
select distinct name,pricefrom app_store_apps
where price between 0 and 1;
select sum(price)as total_price from app_store_apps;
select name, price from app_store_apps where rating > 4.0;
/*life span of app*/
select name,rating, round(rating/0.5 +1) as life_span from app_store_apps
order by life_span desc;

/* calculate the life span and amount earn  per */
select a.name, a.rating, round(a.rating/0.5 + 1) * 60000 as total_earnings,
case when a.rating  <= 0 then '1 year'
      when a.rating >= 1 and a.rating < 2 then '3 year'
	  when a.rating >= 2 and a.rating < 3 then '5 years'
	  when a.rating >= 3 and a.rating < 4 then '7 years'
	  when a.rating >= 4 then '9years'
end as App_Year
	  from app_store_apps as a
	  inner join play_store_apps as p
	  on a.name = p.name
	  order by total_earnings desc
	  limit 10;
	  
	  
select name, rating, round(rating/0.5 + 1) * 60000 as total_earnings,
case when rating  <= 0 then '1 year'
      when rating >= 1 and rating < 2 then '3 year'
	  when rating >= 2 and rating < 3 then '5 years'
	  when rating >= 3 and rating < 4 then '7 years'
	  when rating >= 4 then '9years'
end as App_Year
	  from app_store_apps 
	  order by total_earnings desc
	  limit 10;
/*Join two tables by union*/	  
	  
select name ,'App_Store' as App,floor(rating * 2  + 0.5) / 2 as rat , round(rating/0.5 + 1) * 60000 as total_earnings,
case when rating  <= 0 then '1 year'
      when rating >= 1 and rating < 2 then '3 year'
	  when rating >= 2 and rating < 3 then '5 years'
	  when rating >= 3 and rating < 4 then '7 years'
	  when rating >= 4 then '9years'
end as life_span_app_store
	  from app_store_apps 
	  
	  Union 
	  
select name,'Play_Store'as App,floor(rating * 2  + 0.5) / 2 as rat , round(rating/0.5 + 1) * 60000 as total_earnings,
case when rating  <= 0 then '1 year'
      when rating >= 1 and rating < 2 then '3 year'
	  when rating >= 2 and rating < 3 then '5 years'
	  when rating >= 3 and rating < 4 then '7 years'
	  when rating >= 4 then '9years'
end as life_span_play_store
	  from play_store_apps
	  order by total_earnings asc;
/*select distinct genre from app_store and calculate the sum of price*/	  
select distinct primary_genre, name, sum(price) as total_price, rating from app_store_apps
group by primary_genre, name, rating
order by total_price desc;

select primary_genre , rating, total_price * 10000 as purchase_price from 
(select primary_genre,rating, sum(price) as total_price from app_store_apps
where rating > 3.5 and primary_genre = 'Music'
group by primary_genre , rating) as subquery
order by purchase_price desc;

/*join two table by union and calculate the revenue for each app*/
select 'app_store'as store, name, total_purchase_price,total_app_revenue,marketing_cost, genre,
(total_app_revenue - total_purchase_price - marketing_cost) as net_profit
 from
 (select 'app_store' as store, name,price, rating, primary_genre as genre,
 (1+2 * rating) * 60000 as total_app_revenue, (1+2 * rating) * 12 * 1000 as marketing_cost,
  case when price = 1.00 then 1000 else price * 10000
  end as total_purchase_price
  from app_store_apps 
  group by name, price,rating,genre) as subquery
  
  union 
  
 select 'play_store' as store, name, total_purchase_price,total_app_revenue,marketing_cost, genre,
(total_app_revenue - total_purchase_price - marketing_cost) as net_profit
 from
 (select 'play_store' as store, name,price::money::numeric::float8, rating, genres as genre,
 (1+2 * rating) * 60000 as total_app_revenue, (1+2 * rating) * 12 * 1000 as marketing_cost,
  case when price::money::numeric::float8 = 1.00 then 1000 else price::money::numeric::float8 * 10000
  end as total_purchase_price
  from play_store_apps
  group by name, price::money::numeric::float8,rating,genre) as subquery
  where total_app_revenue is not null
  order by net_profit desc;
  
 
select round(rating,1) from play_store_apps;

select round((floor(rating * 2  + 0.5) / 2),1) from app_store_apps
where rating is not null;
/*find out the profit of books*/
select name, total_purchase_price,total_app_revenue,marketing_cost, genre,
(total_app_revenue - total_purchase_price - marketing_cost) as net_profit
 from
 (select  name,price, rating, primary_genre as genre,
 (1+2 * rating) * 60000 as total_app_revenue, (1+2 * rating) * 12 * 1000 as marketing_cost,
  case when price = 1.00 then 1000 else price * 10000
  end as total_purchase_price
  from app_store_apps 
  group by name, price,rating,genre) as subquery
  order by net_profit desc;
  select distinct primary_genre from app_store_apps;
select name, rating, purchase_price,revenue, marketing_cost, genre,
(revenue - purchase_price - marketing_cost) as profit
 from
 (select  name,price, rating, primary_genre as genre,
 (1+2 * rating) * 60000 as revenue, (1+2 * rating) * 12 * 1000 as marketing_cost,
  case when price = 1.00 then 1000 else price * 10000
  end as purchase_price
  from app_store_apps 
  where primary_genre in ('Book')
  group by name, price,rating,genre) as foo;
  
 /*find out the only games only for kids which has rating above*/
 
select  distinct name, price, content_rating from app_store_apps
where price < 1 and primary_genre in ('Games') and rating > 4.5 and content_rating in ('4+');


/*Table join with inner*/


select distinct a.name,a.price,a.rating, a.primary_genre as genre
from app_store_apps as a
inner join play_store_apps as p
on a.name = p.name;
/*joing tables by union all */
select distinct name, price, rating , primary_genre as genre from app_store_apps
union all
select distinct name,price::money::numeric::float8, rating, genres from play_store_apps;
 
 /*Now try to rank apps on both store to see whether any app repeating in data*/
select distinct p.name, p.price, p.rating,p.genres as genre,dense_rank() over (order by p.name asc) as app_no
from play_store_apps as p
inner join app_store_apps as a
on p.name = a.name; 

/*Now find out all net_profit and revenue from both of these stores by inner join*/
 select distinct name,genre,price,rating, total_purchase_price,total_app_revenue,marketing_cost, genre,
(total_app_revenue - total_purchase_price - marketing_cost) as net_profit
 from
 (select a.name,a.price, a.rating, a.primary_genre as genre,
 (1+2 * a.rating) * 60000 as total_app_revenue, (1+2 * a.rating) * 12 * 1000 as marketing_cost,
  case when a.price = 0.0 then 10000 else a.price * 10000
  end as total_purchase_price
  from app_store_apps as a
  join play_store_apps as p
  on a.name = p.name 
  group by a.name, a.price,a.rating,genre) as subquery
  order by net_profit desc;
  /*which genre has max no of apps in app_store*/
  select primary_genre as genre, count(primary_genre) as total_genre
  from app_store_apps
  group by primary_genre
  order by total_genre desc;
  /*which genre has max no of apps in play_store*/
  select genres, count(genres) as total_genre
  from play_store_apps
  group by genres
  order by total_genre desc;
  /*which genre has max no of apps in both stores*/
  select p.genres, count(p.genres) as total_genre
  from play_store_apps as p
  inner join app_store_apps as a
  on p.genres = a.primary_genre
  group by p.genres
  order by total_genre desc;
  /*calculate the percentage of apps which are free on app_store*/
  select count(name) as total_apps  from app_store_apps  
  where price = 0 ;
  /*count how many apps are free and how many apps are price*/
 select name as total_apps,
 count(case when price = 0 then name end) as free_apps,
 count(case when price > 0 then name end) as Pice_apps
 from app_store_apps
 group by name;
 /*count of total app vs free apps on app_store*/
 select count(name) as total_apps,
(select count(name)from app_store_apps where price = 0.0)
as free_apps 
from app_store_apps;
 /*count of apps vs free apps on play_store*/ 
select count(name) as total_apps,
(select count(name)from play_store_apps where price::money::numeric::float8 = 0.0)
as free_apps 
from play_store_apps;

/*count of genre which are free*/

select primary_genre as genre, count(primary_genre) 
from app_store_apps
where price = 0.0
group by primary_genre;

/*How many app which are free and highest rating in both store*/

select a.name, a.primary_genre as genre, a.rating
from app_store_apps as a
inner join play_store_apps as p
on a.name = p.name
where a.rating > 4.5 and a.price = 0.0
group by a.name, a.primary_genre,a.rating;

/* which content_rating has no of apps in app_store*/
select content_rating, count(content_rating) as count,
case when content_rating in ('4+') then 'Junior kids'
      when content_rating in ('9+') then ' kids'
	  when content_rating in ('12+') then 'Teenage'
	  when content_rating in ('17+') then 'Adult'
	  end as rating_bucket
from app_store_apps	  
group by content_rating
order by count desc;

/* which content_rating has no of apps in play_store*/
select content_rating, count(content_rating) as count
from play_store_apps	  
group by content_rating
order by count desc;

/*which app has the highest install count in play_store*/
select name,genres,install_count
from play_store_apps
group by name,genres,install_count
order by install_count desc;


/*select the sum of price of each genre in app store*/

select sum(price) as price, primary_genre
from app_store_apps
group by primary_genre
order by price desc;

/*select the sum of price of each genre in google play*/

select sum(price::money::numeric::float8) as price, genres
from play_store_apps
group by genres
order by price desc;

/*find the top ten genre based on net profit*/ 
select distinct genre,rating, total_purchase_price,total_app_revenue,marketing_cost,
(total_app_revenue - total_purchase_price - marketing_cost) as net_profit
 from
 (select a.primary_genre as app_genre,a.price as app_price, a.rating as app_rating,a.genres as play_genre,
  
 (1+2 * a.rating) * 60000 as total_app_revenue, (1+2 * a.rating) * 12 * 1000 as marketing_cost,
  case when a.price = 0.0 then 10000 else a.price * 10000
  end as total_purchase_price
  from app_store_apps as a
  join play_store_apps as p
  on a.name = p.name 
  group by a.primary_genre,a.price,a.rating) as subquery
  order by net_profit desc;
/*count the genre in both store*/

select  genre,gcount,rating, total_purchase_price,total_app_revenue,marketing_cost,
(total_app_revenue - total_purchase_price - marketing_cost) as net_profit
 from
 (select a.primary_genre as genre,count(a.primary_genre) as gcount,a.price, a.rating,
 (1+2 * a.rating) * 60000 as total_app_revenue, (1+2 * a.rating) * 12 * 1000 as marketing_cost,
  case when a.price = 0.0 then 10000 else a.price * 10000
  end as total_purchase_price
  from app_store_apps as a
  join play_store_apps as p
  on a.name = p.name 
  group by a.primary_genre,a.price,a.rating) as subquery
  order by gcount desc;
/* now find out the both apps from both store*/
select distinct name,genre,price,rating, total_purchase_price,total_app_revenue,marketing_cost, genre,
(total_app_revenue - total_purchase_price - marketing_cost) as net_profit
 from
 (select p.name,p.price::money::numeric::float8, p.rating, p.genres as genre,
 (1+2 * p.rating) * 60000 as total_app_revenue, (1+2 * p.rating) * 12 * 1000 as marketing_cost,
  case when p.price::money::numeric::float8 = 0.0 then 10000 else p.price::money::numeric::float8 * 10000
  end as total_purchase_price
  from app_store_apps as a
  join play_store_apps as p
  on a.name = p.name 
  group by p.name, p.price::money::numeric::float8,p.rating,genre) as subquery
  order by net_profit desc;
  
 
/*count the genre and avg profit for each genre by common table expressions*/
with cal as (select a.name,
 (1+2 * a.rating) * 60000 as total_app_revenue, (1+2 * a.rating) * 12 * 1000 as marketing_cost,
  case when a.price = 0.0 then 10000 else a.price * 10000
  end as total_purchase_price
  from app_store_apps as a
  join play_store_apps as p
  on a.name = p.name )
  
select a.primary_genre, count(primary_genre) as count, sum(cal.total_app_revenue - cal.total_purchase_price-cal.marketing_cost)as
total_profit
from app_store_apps as a
left join cal on a.name = cal.name
group by a.primary_genre
order by total_profit desc;

/*calculate the net profit for both stores*/
select distinct name,genre,price,rating, total_purchase_price,total_app_revenue,marketing_cost, genre,
(total_app_revenue - total_purchase_price - marketing_cost) as net_profit_app,
 from
 (select a.name,a.price, a.rating, a.primary_genre as app_genre,p.genres as play_genre
 (1+2 * a.rating) * 60000 as total_app_revenue_app, (1+2 * a.rating) * 12 * 500 as marketing_cost_app,
  (1+2 * p.rating) * 60000 as total_app_revenue_play, (1+2 * p.rating) * 12 * 500 as marketing_cost_play,
  case when a.price = 0.0 then 10000 else a.price * 10000
  end as total_purchase_price_app
  case when p.price::money::numeric::float8 = 0.0 then 10000 else p.price::money::numeric::float8*10000
  end as total_purchase_price_play
  from app_store_apps as a
  join play_store_apps as p
  on a.name = p.name 
  group by a.name, a.price,a.rating,genre) as subquery
  order by net_profit desc;
  
  /*calculate only shopping apps revenue from app store  */
  
select distinct name,primary_genre,price,rating, total_purchase_price,total_app_revenue,marketing_cost, 
(total_app_revenue - total_purchase_price - marketing_cost) as net_profit
 from
 (select name,price, rating, primary_genre ,
 (1+2 * rating) * 60000 as total_app_revenue, (1+2 * rating) * 12 * 1000 as marketing_cost,
  case when price = 0.0 then 10000 else price * 10000
  end as total_purchase_price
  from app_store_apps 
  where primary_genre = 'Shopping'
  group by name,primary_genre, price,rating) as s
  order by net_profit desc;
  
 /*calculate only shopping apps revenue from play store  */
 
select distinct name,genres,price,rating,install_count, total_purchase_price,total_app_revenue,marketing_cost, 
(total_app_revenue - total_purchase_price - marketing_cost) as net_profit
 from
 (select name,price::money::numeric::float8 as price, rating, genres ,install_count,
 (1+2 * rating) * 60000 as total_app_revenue, (1+2 * rating) * 12 * 1000 as marketing_cost,
  case when price::money::numeric::float8 = 0.0 then 10000 else price::money::numeric::float8 * 10000
  end as total_purchase_price
  from play_store_apps 
  where genres = 'Shopping' 
  group by name,genres, price::money::numeric::float8,rating,install_count) as s
  order by net_profit desc;
  
  
		 
/*Calculate the total Profit for both store*/
		 
select distinct name, genre,app_genre,app_price,pprice, app_rating,rating, 
(total_app_revenue_app - total_purchase_price_app - marketing_cost_app) as net_profit_app,
(total_app_revenue_play - total_purchase_price_play - marketing_cost_play) as net_profit_play,
(total_app_revenue_app -total_purchase_price_app - marketing_cost_app)+ (total_app_revenue_play - total_purchase_price_play - marketing_cost_play) as total_profit
 from
(select a.name as name ,a.primary_genre as app_genre,p.genres as genre,a.price as app_price,p.price::money::numeric::float8 as pprice ,a.rating as app_rating,
  p.rating as rating,
 (1+2 * a.rating) * 60000 as total_app_revenue_app,(1+2 * p.rating) * 60000 as total_app_revenue_play,
  (1+2 * a.rating) * 12 * 500 as marketing_cost_app,
  (1+2 * p.rating) * 12 * 500 as marketing_cost_play,
  case when a.price = 0.0 then 10000 else a.price * 10000
  end as total_purchase_price_app,
  case when p.price::money::numeric::float8 = 0.0 then 10000 else p.price::money::numeric::float8 * 10000
  end as total_purchase_price_play
  from app_store_apps as a
  join play_store_apps as p
  on a.name = p.name 
  group by a.name,a.primary_genre,a.price,a.rating,p.genres,p.price::money::numeric::float8,p.rating) as subquery 
  order by total_profit desc;

/*Checking some data quality issues*/
		 
select name,rating from play_store_apps
where name ilike 'Word%';
		 
select name, rating,install_count from play_store_apps
where rating is null;

		 
/*now get the  same results with common table expressions to get the total_profit*/

with cte as(select a.name as name ,a.primary_genre as app_genre,p.genres as genre,a.price as app_price,p.price::money::numeric::float8 as pprice ,a.rating as app_rating,
  p.rating as rating,
 (1+2 * a.rating) * 60000 as total_app_revenue_app,(1+2 * p.rating) * 60000 as total_app_revenue_play,
  (1+2 * a.rating) * 12 * 500 as marketing_cost_app,
  (1+2 * p.rating) * 12 * 500 as marketing_cost_play,
  case when a.price = 0.0 then 10000 else a.price * 10000
  end as total_purchase_price_app,
  case when p.price::money::numeric::float8 = 0.0 then 10000 else p.price::money::numeric::float8 * 10000
  end as total_purchase_price_play
  from app_store_apps as a
  join play_store_apps as p
  on a.name = p.name 
  group by a.name,a.primary_genre,a.price,a.rating,p.genres,p.price::money::numeric::float8,p.rating)
select distinct cte.name, cte.genre,cte.app_genre,cte.app_price,cte.pprice, cte.app_rating,cte.rating, 
(cte.total_app_revenue_app - cte.total_purchase_price_app - cte.marketing_cost_app) as net_profit_app,
(cte.total_app_revenue_play - cte.total_purchase_price_play - cte.marketing_cost_play) as net_profit_play,
(cte.total_app_revenue_app -cte.total_purchase_price_app - cte.marketing_cost_app)+ (cte.total_app_revenue_play - cte.total_purchase_price_play - cte.marketing_cost_play) as total_profit
from cte
join app_store_apps as a
on cte.name = a.name
order by total_profit desc;

 /*count no of genre and sum revenue and total_profit*/
 with cte as(select a.name,
 (1+2 * a.rating) * 60000 as total_app_revenue_app,(1+2 * p.rating) * 60000 as total_app_revenue_play,
  (1+2 * a.rating) * 12 * 500 as marketing_cost_app,
  (1+2 * p.rating) * 12 * 500 as marketing_cost_play,
  case when a.price = 0.0 then 10000 else a.price * 10000
  end as total_purchase_price_app,
  case when p.price::money::numeric::float8 = 0.0 then 10000 else p.price::money::numeric::float8 * 10000
  end as total_purchase_price_play
  from app_store_apps as a
  join play_store_apps as p
  on a.name = p.name 
  group by a.name,a.rating,p.rating,a.price,p.price::money::numeric::float8)
select a.primary_genre,count(a.primary_genre) as countgen,
sum(cte.total_app_revenue_app - cte.total_purchase_price_app - cte.marketing_cost_app) as net_profit_app,
sum(cte.total_app_revenue_play - cte.total_purchase_price_play - cte.marketing_cost_play) as net_profit_play,
sum(cte.total_app_revenue_app -cte.total_purchase_price_app - cte.marketing_cost_app)+ sum(cte.total_app_revenue_play - cte.total_purchase_price_play - cte.marketing_cost_play) as total_profit
from cte
join app_store_apps as a
on cte.name = a.name
group by a.primary_genre
order by total_profit desc;


	 
	  
	  
	  

	  

	  
	  
	  
	  

	  

	


	

USE yelp_pittsburgh;

select 	b.neighborhood as 'Neighborhood', count(r.review_id) as 'Number of reviews', avg(r.review_stars) as 'Avarage stars', count(Distinct b.business_id) as 'Number of Businesses in Neightborhood'
from	fact_reviews r	left join dim_business b on b.business_id = r.business_id
						#left join dim_users u on r.user_id = u.user_id
						#left join dim_dates d on r.date_id = d.date_id
where neighborhood is not Null 
group by b.neighborhood
order by count(r.review_id) desc;

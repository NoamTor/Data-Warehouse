USE yelp_pittsburgh;

CREATE TEMPORARY TABLE IF NOT EXISTS neighborhood_reviews AS
(
select t2.neighborhood, t1.review_num as review_num
    from
    (select neighborhood, count(Distinct review_id) as review_num from dim_business b right outer join fact_reviews r on b.business_id = r.business_id group by b.neighborhood) as t1
	right outer join
    (select distinct(b1.neighborhood) from dim_business b1) as t2
    on t2.neighborhood = t1.neighborhood
)    
;

select 	b.neighborhood as 'Neighborhood',
		count(r.review_id) as 'Number of reviews',
		count(Distinct b.business_id) as 'Number of Businesses in Neightborhood',
        count(r.review_id) / count(Distinct b.business_id) as 'AVG Review to Business',
        truncate(avg(r.review_stars),4) as 'Avarage stars',
        truncate(std(r.review_stars),4) as 'STD stars'
        
from	fact_reviews r	left join dim_business b on b.business_id = r.business_id
						left join dim_dates d on r.date_id = d.date_id
                        
where	neighborhood is not Null
		and d.date >= curdate() - interval 2 year
        
group by b.neighborhood

having count(r.review_id) > (select avg(review_num) from neighborhood_reviews)

order by count(r.review_id) desc;


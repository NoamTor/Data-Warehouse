USE yelp_pittsburgh;

DROP TABLE IF EXISTS ratings_2015Q1;
DROP TABLE IF EXISTS ratings_2015Q2;
DROP TABLE IF EXISTS ratings_2015Q3;
DROP TABLE IF EXISTS ratings_2015Q4;
DROP TABLE IF EXISTS ratings_2016Q1;
DROP TABLE IF EXISTS ratings_2016Q2;
DROP TABLE IF EXISTS ratings_2016Q3;
DROP TABLE IF EXISTS ratings_2016Q4;

CREATE TEMPORARY TABLE IF NOT EXISTS ratings_2015Q1 AS
(
SELECT r.business_id , count(r.review_id), sum(power(r.review_stars-3, 3) * (r.votes_aggregate*0.2 + 1) * (1 + u.is_elite)) as rating
FROM fact_reviews r left outer join dim_users u on r.user_id = u.user_id
		left join dim_dates d on r.date_id = d.date_id
WHERE d.year = 2015 and d.month between 1 AND 3
GROUP BY r.business_id
);
#HAVING count(r.review_id) > 3;


CREATE TEMPORARY TABLE IF NOT EXISTS ratings_2015Q2 AS
(
SELECT r.business_id , count(r.review_id), sum(power(r.review_stars-3, 3) * (r.votes_aggregate*0.2 + 1) * (1 + u.is_elite)) as rating
FROM fact_reviews r left outer join dim_users u on r.user_id = u.user_id
		left join dim_dates d on r.date_id = d.date_id
WHERE d.year = 2015 and d.month between 4 AND 6
GROUP BY r.business_id
);


CREATE TEMPORARY TABLE IF NOT EXISTS ratings_2015Q3 AS
(
SELECT r.business_id , count(r.review_id), sum(power(r.review_stars-3, 3) * (r.votes_aggregate*0.2 + 1) * (1 + u.is_elite)) as rating
FROM fact_reviews r left outer join dim_users u on r.user_id = u.user_id
		left join dim_dates d on r.date_id = d.date_id
WHERE d.year = 2015 and d.month between 7 AND 9
GROUP BY r.business_id
);

CREATE TEMPORARY TABLE IF NOT EXISTS ratings_2015Q4 AS
(
SELECT r.business_id , count(r.review_id), sum(power(r.review_stars-3, 3) * (r.votes_aggregate*0.2 + 1) * (1 + u.is_elite)) as rating
FROM fact_reviews r left outer join dim_users u on r.user_id = u.user_id
		left join dim_dates d on r.date_id = d.date_id
WHERE d.year = 2015 and d.month between 10 AND 12
GROUP BY r.business_id
);


CREATE TEMPORARY TABLE IF NOT EXISTS ratings_2016Q1 AS
(
SELECT r.business_id , count(r.review_id), sum(power(r.review_stars-3, 3) * (r.votes_aggregate*0.2 + 1) * (1 + u.is_elite)) as rating
FROM fact_reviews r left outer join dim_users u on r.user_id = u.user_id
		left join dim_dates d on r.date_id = d.date_id
WHERE d.year = 2016 and d.month between 1 AND 3
GROUP BY r.business_id
);
#HAVING count(r.review_id) > 3;


CREATE TEMPORARY TABLE IF NOT EXISTS ratings_2016Q2 AS
(
SELECT r.business_id , count(r.review_id), sum(power(r.review_stars-3, 3) * (r.votes_aggregate*0.2 + 1) * (1 + u.is_elite)) as rating
FROM fact_reviews r left outer join dim_users u on r.user_id = u.user_id
		left join dim_dates d on r.date_id = d.date_id
WHERE d.year = 2016 and d.month between 4 AND 6
GROUP BY r.business_id
);


CREATE TEMPORARY TABLE IF NOT EXISTS ratings_2016Q3 AS
(
SELECT r.business_id , count(r.review_id), sum(power(r.review_stars-3, 3) * (r.votes_aggregate*0.2 + 1) * (1 + u.is_elite)) as rating
FROM fact_reviews r left outer join dim_users u on r.user_id = u.user_id
		left join dim_dates d on r.date_id = d.date_id
WHERE d.year = 2016 and d.month between 7 AND 9
GROUP BY r.business_id
);

CREATE TEMPORARY TABLE IF NOT EXISTS ratings_2016Q4 AS
(
SELECT r.business_id , count(r.review_id), sum(power(r.review_stars-3, 3) * (r.votes_aggregate*0.2 + 1) * (1 + u.is_elite)) as rating
FROM fact_reviews r left outer join dim_users u on r.user_id = u.user_id
		left join dim_dates d on r.date_id = d.date_id
WHERE d.year = 2016 and d.month between 10 AND 12
GROUP BY r.business_id
);



set @beta = 0.7;
set @alpha = 1-@beta;

SELECT	b.business_id,  r15q1.rating as rating_2015Q1,
						r15q2.rating as rating_2015Q2,
                        r15q3.rating as rating_2015Q3,
                        r15q4.rating as rating_2015Q4,
                        
                        r16q1.rating as rating_2016Q1,
                        r16q2.rating as rating_2016Q2,
                        r16q3.rating as rating_2016Q3,
                        r16q4.rating as rating_2016Q4,
                        @alpha * (power(@beta, 0) * r16q4.rating + power(@beta, 1) * r16q3.rating + power(@beta, 2) * r16q2.rating + power(@beta, 3) * r16q1.rating + power(@beta, 4) * r15q4.rating + power(@beta, 5) * r15q3.rating + power(@beta, 6) * r15q2.rating) + power(@beta,7) * r15q1.rating AS rating_exponential_smoothing
                        
FROM dim_business b  join ratings_2015Q1 r15q1 on b.business_id = r15q1.business_id
					 join ratings_2015Q2 r15q2 on b.business_id = r15q2.business_id
                     join ratings_2015Q3 r15q3 on b.business_id = r15q3.business_id
                     join ratings_2015Q4 r15q4 on b.business_id = r15q4.business_id
                     join ratings_2016Q1 r16q1 on b.business_id = r16q1.business_id
					 join ratings_2016Q2 r16q2 on b.business_id = r16q2.business_id
                     join ratings_2016Q3 r16q3 on b.business_id = r16q3.business_id
                     join ratings_2016Q4 r16q4 on b.business_id = r16q4.business_id

ORDER BY rating_exponential_smoothing DESC
LIMIT 10;
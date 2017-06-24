USE yelp_pittsburgh;

DROP TABLE IF EXISTS Num_of_Business;
DROP TABLE IF EXISTS Num_of_categories;

CREATE TEMPORARY TABLE IF NOT EXISTS Num_of_Business AS
(
SELECT Distinct neighborhood, count(Distinct business_id) as total_count
FROM yelp_pittsburgh.dim_business
group by neighborhood
);

CREATE TEMPORARY TABLE IF NOT EXISTS Num_of_categories AS
(
SELECT Distinct neighborhood, sum(food) as 'food', sum(`art & enteraitment`) as 'art & enteraitment', sum(stores) as 'stores',
sum(`beauty & spa`) as 'beauty & spa', sum(health) as 'health', sum(finance) as 'finance',
sum(turists) as 'turists', sum(`cars & transportation`) as 'cars & transportation', 
sum(`bars & alcohol`) as 'bars & alcohol', sum(other) as 'other', sum(fashion) as 'fashion'
from yelp_pittsburgh.dim_business 
group by neighborhood
);

SELECT Distinct a.neighborhood, a.food/b.total_count, a.`art & enteraitment`/b.total_count, a.stores/b.total_count,
a.`beauty & spa`/b.total_count, a.health/b.total_count, a.finance/b.total_count,
a.turists/b.total_count, a.`cars & transportation`/b.total_count, a.`bars & alcohol`/b.total_count, a.other/b.total_count,
a.fashion/b.total_count
from Num_of_categories as a join Num_of_Business as b on a.neighborhood=b.neighborhood;

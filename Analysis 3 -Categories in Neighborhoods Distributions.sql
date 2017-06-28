USE yelp_pittsburgh;

DROP TABLE IF EXISTS Num_of_Business;
DROP TABLE IF EXISTS Num_of_categories;

CREATE TEMPORARY TABLE IF NOT EXISTS Num_of_categories AS
(
SELECT Distinct neighborhood, sum(food) as 'food', sum(`art & enteraitment`) as 'art_enteraitment', sum(stores) as 'stores',
sum(`beauty & spa`) as 'beauty_spa', sum(health) as 'health', sum(finance) as 'finance',
sum(turists) as 'turists', sum(`cars & transportation`) as 'cars_transportation', 
sum(`bars & alcohol`) as 'bars_alcohol', sum(other) as 'other', sum(fashion) as 'fashion', sum(`real estate`) as 'real_estate'
from yelp_pittsburgh.dim_business 
where is_open = 1
group by neighborhood
);

CREATE TEMPORARY TABLE IF NOT EXISTS Num_of_Business AS
(
SELECT Distinct neighborhood, (food+art_enteraitment+stores+beauty_spa+health+finance+turists+cars_transportation+bars_alcohol+other+fashion+real_estate) as total_count
FROM Num_of_categories
);

SELECT Distinct a.neighborhood, a.food/b.total_count, a.`art_enteraitment`/b.total_count, a.stores/b.total_count,
				a.`beauty_spa`/b.total_count, a.health/b.total_count, a.finance/b.total_count,
				a.turists/b.total_count, a.`cars_transportation`/b.total_count, a.`bars_alcohol`/b.total_count, a.other/b.total_count,
				a.fashion/b.total_count, a.real_estate/b.total_count
from Num_of_categories as a join Num_of_Business as b on a.neighborhood=b.neighborhood
WHERE a.neighborhood in ('Downtown','South Side','Strip District','Lawrenceville','Shadyside','Oakland','Squirrel Hill','North Side')
;
# ----------------------------- Total opens in pittsburg CATEGORIES -------------------------------------------------------------

DROP TABLE IF EXISTS Num_of_Business;
DROP TABLE IF EXISTS Num_of_categories;

CREATE TEMPORARY TABLE IF NOT EXISTS Num_of_categories AS
(
SELECT  sum(food) as 'food', sum(`art & enteraitment`) as 'art_enteraitment', sum(stores) as 'stores',
sum(`beauty & spa`) as 'beauty_spa', sum(health) as 'health', sum(finance) as 'finance',
sum(turists) as 'turists', sum(`cars & transportation`) as 'cars_transportation', 
sum(`bars & alcohol`) as 'bars_alcohol', sum(other) as 'other', sum(fashion) as 'fashion', sum(`real estate`) as 'real_estate'
from yelp_pittsburgh.dim_business 
where is_open = 1
);

set @total = (SELECT (food+art_enteraitment+stores+beauty_spa+health+finance+turists+cars_transportation+bars_alcohol+other+fashion+real_estate)
				FROM Num_of_categories)
;

select @total;

SELECT Distinct  a.food/@total, a.`art_enteraitment`/@total, a.stores/@total,
				a.`beauty_spa`/@total, a.health/@total, a.finance/@total,
				a.turists/@total, a.`cars_transportation`/@total, a.`bars_alcohol`/@total, a.other/@total,
				a.fashion/@total, a.real_estate/@total
from Num_of_categories as a

# ----------------------------- CLOSED CATEGORIES -------------------------------------------------------------

DROP TABLE IF EXISTS Num_of_categories;
DROP TABLE IF EXISTS Num_of_CLOSED_categories;

CREATE TEMPORARY TABLE IF NOT EXISTS Num_of_categories AS
(
SELECT Distinct neighborhood, sum(food) as 'food', sum(`art & enteraitment`) as 'art_enteraitment', sum(stores) as 'stores',
sum(`beauty & spa`) as 'beauty_spa', sum(health) as 'health', sum(finance) as 'finance',
sum(turists) as 'turists', sum(`cars & transportation`) as 'cars_transportation', 
sum(`bars & alcohol`) as 'bars_alcohol', sum(other) as 'other', sum(fashion) as 'fashion', sum(`real estate`) as 'real_estate'
from yelp_pittsburgh.dim_business 
group by neighborhood
);

CREATE TEMPORARY TABLE IF NOT EXISTS Num_of_CLOSED_categories AS
(
SELECT Distinct neighborhood, sum(food) as 'food', sum(`art & enteraitment`) as 'art_enteraitment', sum(stores) as 'stores',
sum(`beauty & spa`) as 'beauty_spa', sum(health) as 'health', sum(finance) as 'finance',
sum(turists) as 'turists', sum(`cars & transportation`) as 'cars_transportation', 
sum(`bars & alcohol`) as 'bars_alcohol', sum(other) as 'other', sum(fashion) as 'fashion', sum(`real estate`) as 'real_estate'
from yelp_pittsburgh.dim_business 
where is_open = 0
group by neighborhood
);


SELECT Distinct a.neighborhood, a.food/b.food as 'food', a.`art_enteraitment`/b.`art_enteraitment` as 'art_enteraitment', a.stores/b.stores as 'stores',
				a.`beauty_spa`/b.`beauty_spa` 'beauty_spa', a.health/b.health 'health', a.finance/b.finance 'finance',
				a.turists/b.turists as 'turists', a.`cars_transportation`/b.`cars_transportation` as 'cars_transportation', a.`bars_alcohol`/b.`bars_alcohol` as 'bars_alcohol', a.other/b.other as 'other',
				a.fashion/b.fashion as 'fashion', a.real_estate/b.real_estate as 'real_estate'
from Num_of_CLOSED_categories as a join Num_of_categories as b on a.neighborhood=b.neighborhood
WHERE a.neighborhood in ('Downtown','South Side','Strip District','Lawrenceville','Shadyside','Oakland','Squirrel Hill','North Side')
;
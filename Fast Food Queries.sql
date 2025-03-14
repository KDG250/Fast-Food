## Most sugary items by restaurant
WITH item_sugar_count AS (
  SELECT restaurant, item, sugar,
ROW_NUMBER()OVER(Partition by restaurant ORDER BY sugar DESC) as sugary_item_rnk
FROM `spheric-effect-445016-u2.fastfood.fastfood`)
SELECT *
FROM item_sugar_count
WHERE sugary_item_rnk IN (1, 2, 3, 4, 5);

## Items with the most sodium at each restaurant

WITH salty_foods AS (
  SELECT restaurant, item, sodium,
ROW_NUMBER()OVER(Partition by restaurant ORDER BY sodium DESC) as saltiness_rnk
FROM `spheric-effect-445016-u2.fastfood.fastfood`)
SELECT *
FROM salty_foods
WHERE saltiness_rnk <=5;


## Most calorie dense items at each restaurant
WITH item_calorie_count AS (
  SELECT restaurant, item, calories,
ROW_NUMBER()OVER(Partition by restaurant ORDER BY calories DESC) as health_rank
FROM `spheric-effect-445016-u2.fastfood.fastfood`)
SELECT *
FROM item_calorie_count
WHERE health_rank <= 5;

##Fattiest items at each restaurant
WITH fattyfoods AS (
  SELECT restaurant, item, total_fat,
ROW_NUMBER()OVER(Partition by restaurant ORDER BY total_fat DESC) as fatty_food_rank
FROM `spheric-effect-445016-u2.fastfood.fastfood`)
SELECT *
FROM fattyfoods
WHERE fatty_food_rank IN (1, 2, 3, 4, 5);

#Average calorie count per restaurant
SELECT restaurant, ROUND(AVG(calories), 2) as avg_cals_restaurant
FROM spheric-effect-445016-u2.fastfood.fastfood
GROUP BY restaurant
ORDER BY avg_cals_restaurant DESC;

## 10 highest caloried foods 
SELECT restaurant, item, calories
FROM `spheric-effect-445016-u2.fastfood.fastfood`
ORDER BY calories DESC 
LIMIT 10;

# Items with the lowest calories
SELECT restaurant, item, calories
FROM `spheric-effect-445016-u2.fastfood.fastfood`
WHERE calories <400;

# Low calories and fat
SELECT restaurant, item, calories, total_fat
FROM `spheric-effect-445016-u2.fastfood.fastfood`
ORDER BY calories ASC, total_fat ASC
LIMIT 10;


#Health Scores
WITH NutrientAverages AS (
    SELECT 
        restaurant, 
        AVG(calories) AS avg_calories, 
        AVG(total_fat) AS avg_fat, 
        AVG(sodium) AS avg_sodium, 
        AVG(sugar) AS avg_sugar
    FROM `spheric-effect-445016-u2.fastfood.fastfood`
    GROUP BY restaurant
),
HealthScores AS (
    SELECT 
        restaurant,
        (avg_calories * 0.4 + avg_fat * 0.3 + avg_sodium * 0.2 + avg_sugar * 0.1) AS health_score
    FROM NutrientAverages
)
SELECT restaurant, ROUND(health_score, 2) AS health_score
FROM HealthScores
ORDER BY health_score ASC;
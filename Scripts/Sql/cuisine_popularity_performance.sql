/*
Business Problem 2: Analyzing Cuisine Popularity and Performance
Question: What are the most popular cuisine types in terms of the number of restaurants offering them, and how do their average ratings compare? This helps understand market saturation and quality perception for different food types.

Business Value:

For Zomato: Identify dominant cuisine types, potential areas for new cuisine promotion, or gaps in offerings.

For Restaurants: Understand competitive landscape within specific cuisine categories, or identify less saturated but high-demand cuisines.

For Investors: Spot trends in culinary preferences.
*/

SELECT
    cz.cuisine_name,
    COUNT(DISTINCT r.restaurant_id) AS number_of_restaurants,
    AVG(r.rate) AS average_rating_for_cuisine,
    AVG(r.cost_for_two) AS average_cost_for_cuisine
FROM
    cuisines cz
JOIN
    restaurant_cuisines rc ON cz.cuisine_id = rc.cuisine_id
JOIN
    restaurants r ON rc.restaurant_id = r.restaurant_id
WHERE
    r.rate IS NOT NULL -- Only consider restaurants with a rating
GROUP BY
    cz.cuisine_name
HAVING
    COUNT(DISTINCT r.restaurant_id) >= 20 -- Only consider cuisines offered by at least 20 restaurants
ORDER BY
    number_of_restaurants DESC, -- Primary sort: most restaurants first
    average_rating_for_cuisine DESC; -- Secondary sort: higher rating for tie-breaking
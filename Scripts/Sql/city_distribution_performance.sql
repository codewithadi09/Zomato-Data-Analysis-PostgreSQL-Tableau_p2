/*
Business Problem 7: Restaurant Distribution Across Cities
Question: How are restaurants distributed across the different cities listed in the dataset? Which cities have the most restaurants, and how do their average ratings and costs compare? This helps understand the overall market size and quality variations at a city level.

Business Value:

For Zomato: Strategic market planning, resource allocation across cities, identifying primary vs. secondary markets.

For Business Expansion: Inform decisions about expanding into new cities or focusing efforts in existing ones.

For Users: Provide context on the dining scene in different cities.
*/


SELECT
    c.city_name,
    COUNT(r.restaurant_id) AS number_of_restaurants_in_city,
    AVG(r.rate) AS average_rating_in_city,
    AVG(r.cost_for_two) AS average_cost_in_city,
    SUM(r.votes) AS total_votes_in_city
FROM
    cities c
JOIN
    restaurants r ON c.city_id = r.city_id
WHERE
    r.rate IS NOT NULL AND r.votes IS NOT NULL AND r.votes > 0 -- Only consider rated restaurants
GROUP BY
    c.city_name
ORDER BY
    number_of_restaurants_in_city DESC, -- Primary sort: most restaurants first
    average_rating_in_city DESC;        -- Secondary sort: higher rating for tie-breaking
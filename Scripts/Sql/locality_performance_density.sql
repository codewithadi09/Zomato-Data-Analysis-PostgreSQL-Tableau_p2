/*
Business Problem 4: Geographical Analysis - Hotspots & Underserved Areas
Question: Where are restaurants most concentrated (hotspots)? Are there localities within Bangalore that have a high number of restaurants but surprisingly low average ratings (indicating over-saturation or quality issues)? Conversely, are there areas with fewer restaurants but high demand/ratings, suggesting underserved markets?

Business Value:

For Zomato: Optimize marketing efforts, identify areas for new restaurant acquisition, or areas where existing restaurants might need support.

For New Restaurants/Investors: Inform location strategy for opening new establishments.

For Users: Help discover high-quality options in less obvious places.
*/

SELECT
    l.locality_name,
    c.city_name,
    COUNT(r.restaurant_id) AS number_of_restaurants,
    AVG(r.rate) AS average_rating_in_locality,
    AVG(r.cost_for_two) AS average_cost_in_locality
FROM
    localities l
JOIN
    restaurants r ON l.locality_id = r.locality_id
JOIN
    cities c ON l.city_id = c.city_id
WHERE
    r.rate IS NOT NULL AND r.votes IS NOT NULL AND r.votes > 0 -- Only consider rated restaurants
GROUP BY
    l.locality_name, c.city_name
HAVING
    COUNT(r.restaurant_id) >= 10 -- Focus on localities with at least 10 restaurants for meaningful averages
ORDER BY
    number_of_restaurants DESC, -- Primary sort: most restaurants first (hotspots)
    average_rating_in_locality DESC; -- Secondary sort: higher rating for tie-breaking
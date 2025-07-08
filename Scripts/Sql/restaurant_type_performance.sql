/*
Business Problem 6: Restaurant Type Performance & Distribution
Question: How do different types of restaurants (e.g., Casual Dining, Cafe, Quick Bites, Pubs) perform in terms of average rating and average cost? Which types are most prevalent, and which offer a higher-quality experience?

Business Value:

For Zomato: Categorize and recommend restaurants by type, identify popular types for user search filters, or spot emerging/declining types.

For Restaurants/Investors: Understand the competitive landscape and typical customer expectations within a specific restaurant type. Inform business models.

For Users: Filter search results based on desired dining experience.
*/


SELECT
    rt.type_name AS restaurant_type,
    COUNT(r.restaurant_id) AS number_of_restaurants,
    AVG(r.rate) AS average_rating_by_type,
    AVG(r.cost_for_two) AS average_cost_by_type,
    SUM(r.votes) AS total_votes_by_type
FROM
    restaurant_types rt
JOIN
    restaurants r ON rt.restaurant_type_id = r.restaurant_type_id
WHERE
    r.rate IS NOT NULL AND r.votes IS NOT NULL AND r.votes > 0
GROUP BY
    rt.type_name
HAVING
    COUNT(r.restaurant_id) >= 10 -- Only include types with at least 10 restaurants for meaningful averages
ORDER BY
    number_of_restaurants DESC, -- Primary sort: most common types first
    average_rating_by_type DESC; -- Secondary sort: higher rating for tie-breaking
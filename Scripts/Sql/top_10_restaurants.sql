/*
Business Problem 1: Identifying Top-Performing Restaurants
Question: As a Zomato analyst or a potential investor, which restaurants are the "best" and most reliable in terms of customer satisfaction? We need to identify top-rated restaurants that also have a significant number of reviews (votes) to ensure their ratings are credible, not just based on a few opinions.

Business Value:

For Zomato: Feature these restaurants in "Editor's Picks," "Top Rated" lists, or recommend them to users.

For Restaurants: Benchmark against top performers, understand what drives success.

For Investors: Identify high-potential businesses.
*/



WITH RankedBranches AS (
    SELECT
        r.restaurant_id,
        r.name AS restaurant_name,
        r.address,
        l.locality_name,
        c.city_name,
        rt.type_name AS restaurant_type,
        AVG(r.rate) AS branch_avg_rating, -- Renamed to avoid confusion with overall rating
        SUM(r.votes) AS branch_total_votes,
        STRING_AGG(DISTINCT cz.cuisine_name, ', ') AS cuisines_offered
    FROM
        restaurants r
    JOIN
        localities l ON r.locality_id = l.locality_id
    JOIN
        cities c ON r.city_id = c.city_id
    LEFT JOIN
        restaurant_types rt ON r.restaurant_type_id = rt.restaurant_type_id
    LEFT JOIN
        restaurant_cuisines rc ON r.restaurant_id = rc.restaurant_id
    LEFT JOIN
        cuisines cz ON rc.cuisine_id = cz.cuisine_id
    WHERE
        r.rate IS NOT NULL AND r.votes IS NOT NULL AND r.votes > 0
    GROUP BY
        r.restaurant_id, r.name, r.address, l.locality_name, c.city_name, rt.type_name
    HAVING
        SUM(r.votes) >= 50 -- Keep the minimum vote threshold for credibility
),
-- This CTE ensures we get truly unique branches based on name and address
UniqueRankedBranches AS (
    SELECT DISTINCT ON (restaurant_name, address)
        restaurant_name,
        address,
        locality_name,
        city_name,
        restaurant_type,
        branch_avg_rating AS average_rating, -- Use the averaged rating from the previous CTE
        branch_total_votes AS total_votes,
        cuisines_offered
    FROM
        RankedBranches
    ORDER BY
        restaurant_name, address, -- Required for DISTINCT ON to pick a consistent row
        branch_avg_rating DESC,   -- Prioritize higher rating for duplicates
        branch_total_votes DESC   -- Then higher votes for duplicates
)
SELECT
    restaurant_name,
    address,
    locality_name,
    city_name,
    restaurant_type,
    average_rating,
    total_votes,
    cuisines_offered
FROM
    UniqueRankedBranches
ORDER BY
    average_rating DESC,
    total_votes DESC
LIMIT 10;
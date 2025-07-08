/*
Business Problem 5: Cost vs. Rating Analysis (Value for Money)
Question: What is the relationship between the average cost of a meal for two at a restaurant and its customer rating? Are more expensive restaurants always better rated, or can customers find high-quality experiences at more affordable prices? This helps identify "value for money" segments and premium markets.

Business Value:

For Zomato: Create "Value for Money" collections, "Premium Dining" lists, or insights for users looking for specific price points.

For Restaurants: Understand where they stand in their price segment relative to customer perception. Helps in pricing strategy.

For Users: Guide dining choices based on budget and desired quality.
*/

SELECT
    CASE
        WHEN r.cost_for_two < 300 THEN '1. Budget (< ₹300)'
        WHEN r.cost_for_two >= 300 AND r.cost_for_two < 700 THEN '2. Mid-Range (₹300 - ₹699)'
        WHEN r.cost_for_two >= 700 AND r.cost_for_two < 1500 THEN '3. Premium (₹700 - ₹1499)'
        WHEN r.cost_for_two >= 1500 THEN '4. Luxury (₹1500+)'
        ELSE '5. Unknown Cost' -- Handle cases where cost_for_two might be NULL or unparsed
    END AS cost_category,
    COUNT(r.restaurant_id) AS number_of_restaurants,
    AVG(r.rate) AS average_rating_in_category,
    SUM(r.votes) AS total_votes_in_category,
    MIN(r.cost_for_two) AS min_cost_in_category, -- For ordering purposes
    MAX(r.cost_for_two) AS max_cost_in_category  -- For context
FROM
    restaurants r
WHERE
    r.rate IS NOT NULL AND r.votes IS NOT NULL AND r.votes > 0
GROUP BY
    cost_category
ORDER BY
    min_cost_in_category; -- Ensures categories are ordered logically by price
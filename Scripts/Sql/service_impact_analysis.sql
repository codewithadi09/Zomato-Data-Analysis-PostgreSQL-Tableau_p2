/*
Business Problem 3: Impact of Online Ordering and Table Booking on Restaurant Success
Question: Does offering services like online ordering or table booking significantly impact a restaurant's average rating or its prevalence in the market? This helps Zomato advise restaurants on which services to prioritize.

Business Value:

For Zomato: Advise partner restaurants on service adoption, highlight benefits of certain features.

For Restaurants: Strategic decision-making on investing in online presence or booking systems.
*/

SELECT
    CASE WHEN r.online_order THEN 'Online Order Available' ELSE 'Online Order Not Available' END AS online_order_status,
    CASE WHEN r.book_table THEN 'Table Booking Available' ELSE 'Table Booking Not Available' END AS table_booking_status,
    COUNT(r.restaurant_id) AS number_of_restaurants,
    AVG(r.rate) AS average_rating_for_group
FROM
    restaurants r
WHERE
    r.rate IS NOT NULL
GROUP BY
    r.online_order, r.book_table
ORDER BY
    number_of_restaurants DESC; -- Order by count to see the most common combinations first
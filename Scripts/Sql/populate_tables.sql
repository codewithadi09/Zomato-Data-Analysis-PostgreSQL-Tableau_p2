-- Populating cities table
INSERT INTO cities (city_name)
SELECT DISTINCT TRIM(LOWER("listed_in(city)"))
FROM zomato_raw
WHERE "listed_in(city)" IS NOT NULL AND "listed_in(city)" != ''
ON CONFLICT (city_name) DO NOTHING;


-- Populating localities table
INSERT INTO localities (locality_name, city_id)
SELECT DISTINCT TRIM(LOWER(zr.location)), c.city_id
FROM zomato_raw zr
JOIN cities c ON TRIM(LOWER(zr."listed_in(city)")) = c.city_name
WHERE zr.location IS NOT NULL AND zr.location != ''
ON CONFLICT (locality_name) DO NOTHING;


-- Populating restaurant_types table
INSERT INTO restaurant_types (type_name)
SELECT DISTINCT TRIM(LOWER(unnest(string_to_array(zr.rest_type, ','))))
FROM zomato_raw zr
WHERE zr.rest_type IS NOT NULL AND zr.rest_type != ''
ON CONFLICT (type_name) DO NOTHING;


-- Populating cuisines table
INSERT INTO cuisines (cuisine_name)
SELECT DISTINCT TRIM(LOWER(unnest(string_to_array(zr.cuisines, ','))))
FROM zomato_raw zr
WHERE zr.cuisines IS NOT NULL AND zr.cuisines != ''
ON CONFLICT (cuisine_name) DO NOTHING;


-- Populating restaurants table
INSERT INTO restaurants (
    name,
    address,
    locality_id,
    city_id,
    online_order,
    book_table,
    cost_for_two,
    zomato_url,
    phone,
    restaurant_type_id, -- This is the column we're fixing
    rate,
    votes,
    listed_in_type,
    listed_in_city
)
SELECT DISTINCT ON (zr.url) -- Use DISTINCT ON to select one unique restaurant entry per URL
    zr.name,
    zr.address,
    l.locality_id,
    c.city_id,
    CASE WHEN LOWER(TRIM(zr.online_order)) = 'yes' THEN TRUE ELSE FALSE END AS online_order,
    CASE WHEN LOWER(TRIM(zr.book_table)) = 'yes' THEN TRUE ELSE FALSE END AS book_table,
    NULLIF(REGEXP_REPLACE(zr."approx_cost(for two people)", '[^0-9.]', '', 'g'), '')::NUMERIC AS cost_for_two,
    zr.url AS zomato_url,
    zr.phone,
    rt.restaurant_type_id, -- Now directly using the ID from the LEFT JOIN
    NULLIF(SUBSTRING(zr.rate FROM '^(\d+(\.\d+)?)'), '')::NUMERIC AS rate,
    NULLIF(zr.votes, '')::INT AS votes,
    zr."listed_in(type)",
    zr."listed_in(city)"
FROM
    zomato_raw zr
LEFT JOIN
    localities l ON TRIM(LOWER(zr.location)) = l.locality_name
LEFT JOIN
    cities c ON TRIM(LOWER(zr."listed_in(city)")) = c.city_name
LEFT JOIN
    restaurant_types rt ON TRIM(LOWER(SPLIT_PART(zr.rest_type, ',', 1))) = rt.type_name -- Extracts the FIRST type and joins
WHERE
    zr.name IS NOT NULL AND zr.name != '' AND zr.url IS NOT NULL -- Ensure essential fields are present
ORDER BY
    zr.url, zr.name, zr.address -- Required for DISTINCT ON to ensure a consistent selection
;


-- Populating restaurants_cuisines table

INSERT INTO restaurant_cuisines (restaurant_id, cuisine_id)
SELECT DISTINCT
    r.restaurant_id,
    c.cuisine_id
FROM
    zomato_raw zr
JOIN
    restaurants r ON zr.name = r.name AND zr.address = r.address -- Assuming name+address uniquely identifies a restaurant
CROSS JOIN LATERAL
    unnest(string_to_array(zr.cuisines, ',')) AS unnested_cuisine
JOIN
    cuisines c ON TRIM(LOWER(unnested_cuisine)) = c.cuisine_name
WHERE
    zr.cuisines IS NOT NULL AND zr.cuisines != ''
ON CONFLICT (restaurant_id, cuisine_id) DO NOTHING;

-- Verify the restaurant_cuisines table:
SELECT COUNT(*) FROM restaurant_cuisines;
SELECT * FROM restaurant_cuisines LIMIT 5;

SELECT reviews_list FROM zomato_raw WHERE reviews_list IS NOT NULL AND reviews_list != '[]' LIMIT 5;


-- Populate users table
INSERT INTO users (user_name) VALUES ('Anonymous') ON CONFLICT (user_name) DO NOTHING;

-- -----------------------------------------------------------------------------
-- Attempted Population of Reviews Table (Skipped due to Complex Data Issues)
-- -----------------------------------------------------------------------------
-- The 'reviews_list' column in the raw dataset presented significant challenges
-- due to its highly inconsistent, non-standard Python-list-like string format
-- containing complex nested structures, various newline characters, and
-- persistent unicode corruption/unescaped characters (e.g., '\xNN' sequences,
-- unescaped double quotes like '""Alice""').
--
-- Despite multiple attempts using advanced PostgreSQL string and JSON functions
-- (REGEXP_REPLACE, REPLACE, JSONB_ARRAY_ELEMENTS, etc.), a robust and reliable
-- SQL-only parsing solution for all review entries proved infeasible without
-- introducing significant data loss or requiring overly brittle, specific regex patterns.
--
-- For the scope of this project and to maintain data integrity,
-- the direct population of the 'reviews' table from 'reviews_list' has been
-- skipped. This demonstrates a pragmatic approach to real-world data challenges,
-- where sometimes the cost of cleaning outweighs the immediate analytical benefit
-- for a specific column, or requires specialized NLP/text processing tools
-- beyond standard SQL.
--
-- The 'reviews' table schema remains defined to showcase the intended
-- normalized database design for this entity.

-- INSERT INTO reviews (
--     restaurant_id,
--     user_id,
--     rating,
--     review_text,
--     review_date
-- )
-- SELECT
--     r.restaurant_id,
--     (SELECT user_id FROM users WHERE user_name = 'Anonymous') AS user_id,
--     NULLIF(SUBSTRING(individual_review_array ->> 0 FROM '(\d+\.?\d*)'), '')::NUMERIC AS rating,
--     TRIM(REGEXP_REPLACE(
--         REGEXP_REPLACE(individual_review_array ->> 1, '^RATED\n\s*', ''),
--         '\\x[0-9a-fA-F]{2}', '', 'g'
--     )) AS review_text,
--     NULL AS review_date
-- FROM
--     zomato_raw zr
-- JOIN
--     restaurants r ON zr.url = r.zomato_url
-- CROSS JOIN LATERAL (
--     SELECT
--         REPLACE(
--             REPLACE(
--                 REPLACE(
--                     REPLACE(
--                         REGEXP_REPLACE(zr.reviews_list, '\\x[0-9a-fA-F]{2}', '', 'g'),
--                         '''', '"'
--                     ),
--                     '""', '\"'
--                 ),
--                 '(', '['
--             ),
--             ')', ']'
--         )::JSONB AS cleaned_json_reviews_array
-- ) AS json_preparation_step
-- CROSS JOIN LATERAL jsonb_array_elements(json_preparation_step.cleaned_json_reviews_array) AS individual_review_array
-- WHERE
--     zr.reviews_list IS NOT NULL AND zr.reviews_list != '[]';
























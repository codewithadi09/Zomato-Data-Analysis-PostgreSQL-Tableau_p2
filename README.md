# Zomato-Data-Analysis-PostgreSQL-Tableau_p2
Zomato Restaurant Data Analytics Project: End-to-end data analysis project, transforming raw, unstructured Zomato data into a normalized PostgreSQL database for advanced SQL querying and business intelligence visualization.
# Zomato Bangalore Restaurants: Data Modernization & Business Insights Project

This project showcases an end-to-end data analytics workflow, transforming raw, complex Zomato restaurant data into actionable business intelligence. My focus was on solving real-world challenges faced by a food delivery platform or restaurant chain, leveraging **PostgreSQL** for robust data engineering and **Microsoft Power BI** for insightful visualization.

---

## **Project Phases (Current Progress: Phases 1 & 2 Complete!)**

### **Phase 1: Data Modernization & Database Setup (COMPLETED)**

This foundational phase addressed critical data quality and infrastructure challenges to enable reliable business analysis.

**Business Problem Addressed:** Raw operational data is often messy, inconsistent, and unstructured, making it unusable for direct analysis or scalable reporting. This project tackles the challenge of transforming such data into a clean, query-ready format.

**Key Activities & Skills Demonstrated:**

* **Data Acquisition & Initial Assessment:** Sourced a large (500MB+) Zomato dataset from Kaggle, immediately identifying common real-world data quality issues (e.g., malformed CSV structure, inconsistent data types, complex nested string formats).
* **Advanced CSV Handling with Python:**
    * Developed a custom Python script (`scripts/python/clean_zomato_csv.py`) to programmatically clean and re-quote the non-standard CSV. This was crucial for resolving persistent import errors like `"extra data after last expected column"` and `"field larger than field limit"`, demonstrating proficiency in handling real-world data ingestion complexities.
* **Robust PostgreSQL Database Design & Setup:**
    * Designed and implemented a normalized relational schema in PostgreSQL (`zomato_project`), breaking down the monolithic raw data into interconnected tables (`restaurants`, `cities`, `localities`, `cuisines`, `restaurant_types`, `restaurant_cuisines`). This ensures data integrity, reduces redundancy, and optimizes query performance for future analytical needs.
    * **Solution to Data Type Mismatches:** Adapted table schemas (e.g., changing `VARCHAR` to `TEXT`) to accommodate variable-length string data, preventing truncation errors and ensuring data completeness.
* **SQL-driven ETL (Extract, Transform, Load):**
    * Utilized PostgreSQL's `\COPY` command for efficient bulk data import.
    * Wrote sophisticated `INSERT INTO ... SELECT FROM` queries to populate the normalized tables from the cleaned raw data. This involved advanced SQL techniques such as:
        * `TRIM()`, `LOWER()` for data standardization.
        * `DISTINCT ON()` for handling data deduplication.
        * `UNNEST(STRING_TO_ARRAY())` and `SPLIT_PART()` for parsing multi-value fields.
        * `REGEXP_REPLACE()` for cleaning and standardizing numeric and textual data.
        * `CASE` statements for conditional data transformations (e.g., 'Yes'/'No' to Boolean).
        * Extensive use of `JOIN` operations to integrate data across the new relational structure.
    * **Pragmatic Problem-Solving:** Acknowledged and documented the decision to bypass the highly complex `reviews_list` parsing due to extreme and inconsistent data formatting, demonstrating pragmatic judgment in project execution.

---

### **Phase 2: Advanced Business Analysis with SQL (UPCOMING)**

This phase will focus on extracting actionable insights directly from the normalized PostgreSQL database to answer key business questions.

-- Business Problem 1: Identifying Top-Performing Restaurants
-- Question: As a Zomato analyst or a potential investor, which restaurants are the "best" and most reliable in terms of customer satisfaction?
--           We need to identify top-rated restaurants that also have a significant number of reviews (votes) to ensure their ratings are credible,
--           not just based on a few opinions.

-- Business Value:
-- - For Zomato: Enables featuring these restaurants in "Editor's Picks," "Top Rated" lists, or recommending them to users.
-- - For Restaurants: Provides benchmarks against top performers, helping them understand what drives success.
-- - For Investors: Helps identify high-potential businesses for investment.

-- SQL Concepts Used:
-- - CTEs (Common Table Expressions) (`WITH ... AS`): Used to break down complex queries into logical, readable steps (`RankedBranches` and `UniqueRankedBranches`).
-- - JOINs (INNER & LEFT): Combining data from `restaurants`, `localities`, `cities`, `restaurant_types`, `restaurant_cuisines`, and `cuisines` tables
--   based on their foreign key relationships. `LEFT JOIN` is used for `restaurant_types` and `cuisines` to include restaurants even if they
--   somehow don't have a linked type or cuisine (though in a clean dataset, they should).
-- - AVG(), SUM(): Aggregate functions to calculate the average rating and total votes for each restaurant.
-- - GROUP BY: Groups the rows by `restaurant_id` (and other descriptive columns) so that aggregate functions work per restaurant.
-- - HAVING Clause: Filters the *grouped* results. This is essential for applying conditions on aggregate values (e.g., `SUM(r.votes) >= 50`).
--   You cannot use `WHERE` on aggregate values.
-- - DISTINCT ON (column1, column2): Used for advanced deduplication. It selects the *first* row (based on the `ORDER BY` clause) for each unique
--   combination of `restaurant_name` and `address`, ensuring we get truly unique restaurant branches.
-- - ORDER BY: Sorts the results, first by `average_rating` (highest first), then by `total_votes` (more votes break ties).
--   Crucially, it also dictates which row is chosen when `DISTINCT ON` applies.
-- - LIMIT: Restricts the output to the top N results.
-- - STRING_AGG(DISTINCT column, separator): An advanced aggregate function that concatenates all distinct values (e.g., cuisine names)
--   for each grouped entity into a single comma-separated string.

WITH RankedBranches AS (
    SELECT
        r.restaurant_id,
        r.name AS restaurant_name,
        r.address,
        l.locality_name,
        c.city_name,
        rt.type_name AS restaurant_type,
        AVG(r.rate) AS branch_avg_rating,
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
        SUM(r.votes) >= 50 -- Minimum vote threshold for credibility
),
UniqueRankedBranches AS (
    SELECT DISTINCT ON (restaurant_name, address)
        restaurant_name,
        address,
        locality_name,
        city_name,
        restaurant_type,
        branch_avg_rating AS average_rating,
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


-- Business Problem 2: Analyzing Cuisine Popularity and Performance
-- Question: What are the most popular cuisine types in terms of the number of restaurants offering them,
--           and how do their average ratings and costs compare?

-- Business Value:
-- - For Zomato: Helps identify dominant cuisine types, potential areas for new cuisine promotion, or gaps in offerings.
-- - For Restaurants: Provides insights into the competitive landscape within specific cuisine categories,
--   or helps identify less saturated but high-demand cuisines.
-- - For Investors: Spot trends in culinary preferences and market opportunities.

-- SQL Concepts Used:
-- - JOINs: Connecting `cuisines`, `restaurant_cuisines`, and `restaurants` to link cuisine types to restaurant data.
-- - COUNT(DISTINCT ...): Aggregates the number of *unique* restaurants offering each cuisine.
-- - AVG(): Calculates the average rating and average cost for two people for each cuisine.
-- - GROUP BY: Groups the results by `cuisine_name`.
-- - HAVING Clause: Filters out less common cuisines to focus on statistically significant categories.
-- - ORDER BY: Sorts to show the most popular and highest-rated cuisines first.

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
    r.rate IS NOT NULL -- Only consider restaurants with a valid rating
GROUP BY
    cz.cuisine_name
HAVING
    COUNT(DISTINCT r.restaurant_id) >= 20 -- Minimum threshold to focus on significant cuisine categories
ORDER BY
    number_of_restaurants DESC, -- Primary sort: most restaurants first
    average_rating_for_cuisine DESC; -- Secondary sort: higher rating for tie-breaking

-- Business Problem 3: Impact of Online Ordering and Table Booking on Restaurant Success
-- Question: Does offering services like online ordering or table booking significantly impact a restaurant's
--           average rating or its prevalence in the market?

-- Business Value:
-- - For Zomato: Helps advise partner restaurants on feature adoption, highlighting the benefits of certain services.
-- - For Restaurants: Informs strategic decision-making on investing in online presence or table booking systems.
-- - For Users: Provides insights into service availability and its correlation with perceived quality.

-- SQL Concepts Used:
-- - CASE Statements: Creates new categorical dimensions (`online_order_status`, `table_booking_status`) based on boolean flags,
--   making the results more readable for business interpretation.
-- - COUNT() and AVG(): Aggregate functions to count restaurants and calculate average ratings for each service combination.
-- - GROUP BY: Groups the results by the combinations of online order and table booking status.
-- - ORDER BY: Sorts to show the most prevalent combinations first.

SELECT
    CASE WHEN r.online_order THEN 'Online Order Available' ELSE 'Online Order Not Available' END AS online_order_status,
    CASE WHEN r.book_table THEN 'Table Booking Available' ELSE 'Table Booking Not Available' END AS table_booking_status,
    COUNT(r.restaurant_id) AS number_of_restaurants,
    AVG(r.rate) AS average_rating_for_group
FROM
    restaurants r
WHERE
    r.rate IS NOT NULL -- Only consider restaurants with a valid rating
GROUP BY
    r.online_order, r.book_table
ORDER BY
    number_of_restaurants DESC; -- Order by count to see the most common combinations first

-- Business Problem: Geographical Analysis - Hotspots & Underserved Areas
-- Question: Where are restaurants most concentrated (hotspots)? Are there localities within Bangalore that have a high
--           number of restaurants but surprisingly low average ratings (indicating over-saturation or quality issues)?
--           Conversely, are there areas with fewer restaurants but high demand/ratings, suggesting underserved markets?

-- Business Value:
-- - For Zomato: Optimizes marketing efforts, helps identify areas for new restaurant acquisition, or areas where
--   existing restaurants might need support.
-- - For New Restaurants/Investors: Informs location strategy for opening new establishments.
-- - For Users: Helps discover high-quality options in less obvious places.

-- SQL Concepts Used:
-- - JOINs: Combining `localities`, `restaurants`, and `cities` to link geographical data with restaurant performance.
-- - COUNT() and AVG(): Aggregate functions to calculate density (`number_of_restaurants`) and quality (`average_rating_in_locality`,
--   `average_cost_in_locality`) per locality.
-- - GROUP BY: Groups the results by each unique combination of `locality_name` and `city_name`.
-- - HAVING Clause: Filters out localities with very few restaurants, as their averages might not be representative.
-- - ORDER BY: Sorts the results to easily identify the densest areas and their quality.

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

-- Business Problem: Cost vs. Rating Analysis (Value for Money)
-- Question: What is the relationship between the average cost of a meal for two at a restaurant and its customer rating?
--           Are more expensive restaurants always better rated, or can customers find high-quality experiences at more affordable prices?

-- Business Value:
-- - For Zomato: Enables creation of "Value for Money" collections, "Premium Dining" lists, or insights for users
--   looking for specific price points.
-- - For Restaurants: Helps understand where they stand in their price segment relative to customer perception,
--   informing pricing strategy.
-- - For Users: Guides dining choices based on budget and desired quality.

-- SQL Concepts Used:
-- - CASE Statement: The primary tool here, used to create custom, ordered categories (`cost_category`) based on
--   the `cost_for_two` numeric value. The numeric prefixes (e.g., '1.', '2.') are a common trick to ensure
--   correct alphabetical sorting in BI tools when the categories are strings.
-- - COUNT(), AVG(), SUM(), MIN(), MAX(): Standard aggregate functions to summarize data within each cost category.
-- - GROUP BY: Groups the results by the newly defined `cost_category`.
-- - ORDER BY: Sorts the categories by their minimum cost to ensure a logical progression (Budget to Luxury).

SELECT
    CASE
        WHEN r.cost_for_two < 300 THEN '1. Budget (< ₹300)'
        WHEN r.cost_for_two >= 300 AND r.cost_for_two < 700 THEN '2. Mid-Range (₹300 - ₹699)'
        WHEN r.cost_for_two >= 700 AND r.cost_for_two < 1500 THEN '3. Premium (₹700 - ₹1499)'
        WHEN r.cost_for_two >= 1500 THEN '4. Luxury (₹1500+)'
        ELSE '5. Unknown Cost' -- Handles cases where cost_for_two might be NULL or unparsed
    END AS cost_category,
    COUNT(r.restaurant_id) AS number_of_restaurants,
    AVG(r.rate) AS average_rating_in_category,
    SUM(r.votes) AS total_votes_in_category,
    MIN(r.cost_for_two) AS min_cost_in_category,
    MAX(r.cost_for_two) AS max_cost_in_category
FROM
    restaurants r
WHERE
    r.rate IS NOT NULL AND r.votes IS NOT NULL AND r.votes > 0
GROUP BY
    cost_category
ORDER BY
    min_cost_in_category; -- Ensures categories are ordered logically by price

-- Business Problem: Restaurant Type Performance & Distribution
-- Question: How do different types of restaurants (e.g., Casual Dining, Cafe, Quick Bites, Pubs) perform
--           in terms of average rating and average cost? Which types are most prevalent, and which offer
--           a higher-quality experience?

-- Business Value:
-- - For Zomato: Enables categorization and recommendation of restaurants by type, helps identify popular types
--   for user search filters, or spots emerging/declining types.
-- - For Restaurants/Investors: Helps understand the competitive landscape and typical customer expectations
--   within a specific restaurant type, informing business models.
-- - For Users: Allows filtering search results based on desired dining experience.

-- SQL Concepts Used:
-- - JOIN: Connecting `restaurant_types` with `restaurants` to link type names to restaurant performance data.
-- - COUNT(), AVG(), SUM(): Aggregate functions to calculate the number of restaurants, average rating,
--   average cost, and total votes for each type.
-- - GROUP BY: Groups the results by `type_name`.
-- - HAVING Clause: Filters out less common restaurant types to focus on statistically significant categories.
-- - ORDER BY: Sorts to show the most prevalent and highest-rated types first.

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
    COUNT(r.restaurant_id) >= 10 -- Minimum threshold to focus on significant restaurant types
ORDER BY
    number_of_restaurants DESC, -- Primary sort: most common types first
    average_rating_by_type DESC; -- Secondary sort: higher rating for tie-breaking

-- Business Problem: Restaurant Distribution Across Cities
-- Question: How are restaurants distributed across the different cities listed in the dataset? Which cities
--           have the most restaurants, and how do their average ratings and costs compare?

-- Business Value:
-- - For Zomato: Informs strategic market planning, resource allocation across cities, and helps identify
--   primary versus secondary markets.
-- - For Business Expansion: Guides decisions about expanding into new cities or focusing efforts in existing ones.
-- - For Users: Provides context on the overall dining scene in different cities.

-- SQL Concepts Used:
-- - JOIN: Connecting `cities` with `restaurants` to link city names to restaurant performance data.
-- - COUNT(), AVG(), SUM(): Aggregate functions to calculate the number of restaurants, average rating,
--   average cost, and total votes for each city.
-- - GROUP BY: Groups the results by `city_name`.
-- - ORDER BY: Sorts to show the cities with the most restaurants and highest ratings first.

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

---

### **Phase 3: Interactive Business Intelligence Dashboard in Microsoft Power BI (UPCOMING)**

The final phase will translate the analytical findings into compelling, interactive visualizations.

**Business Value Delivered:** Providing intuitive dashboards that empower stakeholders (e.g., Zomato management, restaurant owners, marketing teams) to quickly understand complex data, monitor key performance indicators (KPIs), and make data-driven decisions without needing SQL expertise.

**Key Activities:**
* Connecting Microsoft Power BI Desktop to the PostgreSQL database.
* Designing and building interactive reports and dashboards.
* Leveraging Power BI's visualization capabilities to tell a clear data story.
* Publishing the dashboard (e.g., via screenshots/video) to showcase insights.

---

## **Repository Structure**
.
├── data/
│   ├── zomato.csv             # Original raw dataset (or link to download)
│   └── zomato_cleaned.csv     # Cleaned CSV generated by Python script
├── scripts/
│   ├── python/
│   │   └── clean_zomato_csv.py # Python script for initial CSV cleaning
│   └── sql/
│       ├── create_raw_table.sql         # SQL for creating the zomato_raw table
│       ├── create_normalized_tables.sql # SQL for creating all normalized tables
│       └── populate_tables.sql          # SQL for populating all normalized tables (cities, localities, cuisines, etc.)
├── visualizations/            # (Future: Screenshots/video of Power BI dashboards)
└── README.md                  # Project overview and documentation

---

## **How to Run This Project**

1.  **Clone the repository:** `git clone [your-repo-url]`
2.  **Download `zomato.csv`:** Obtain the original dataset from Kaggle and place it in the `data/` folder.
3.  **Run Python Cleaning Script:** Execute `python scripts/python/clean_zomato_csv.py` to generate `zomato_cleaned.csv`.
4.  **Set up PostgreSQL:** Ensure PostgreSQL is installed and a database (`zomato_project`) is created.
5.  **Execute SQL Scripts:**
    * Run `scripts/sql/create_raw_table.sql` (in your SQL client).
    * Use `\COPY` command in `psql` to import `zomato_cleaned.csv` into `zomato_raw`.
    * Run `scripts/sql/create_normalized_tables.sql` (in your SQL client).
    * Run `scripts/sql/populate_tables.sql` (in your SQL client).
6.  **Connect Power BI:** Use Power BI Desktop to connect to your PostgreSQL database and begin building visualizations.

---

**Author:** Aditya Karmakar

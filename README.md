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

#### **Problem 1: Identifying Top-Performing Restaurants**

* **Business Question:** Which restaurants are the "best" and most reliable in terms of customer satisfaction, considering both high ratings and a significant number of votes?
* **Key Findings/Insights:**
    * The analysis, after careful deduplication of restaurant branches, consistently highlighted establishments like "Byg Brewski Brewing Company" and "AB's - Absolute Barbecues" among the top performers. These are recognized brands with high average ratings (e.g., 4.9) backed by a substantial volume of customer votes (e.g., 80,000+).
    * The application of a minimum vote threshold (e.g., >= 50 votes) was crucial to ensure the credibility of high ratings, filtering out nascent establishments with potentially skewed averages.
* **Business Implications/Recommendations:**
    * **For Zomato:** These top-tier restaurants are prime candidates for prominent featuring in "Editor's Picks," "Top Rated" lists, and targeted user recommendations, driving engagement and trust in the platform.
    * **For New Entrants/Existing Restaurants:** Top performers serve as benchmarks. Analyzing their operational models, cuisine offerings, and service types can provide valuable insights for improving customer satisfaction and market positioning.
* [View SQL Query](scripts/sql/top_10_restaurants.sql)

#### **Problem 2: Analyzing Cuisine Popularity and Performance**

* **Business Question:** What are the most prevalent cuisine types in terms of restaurant count, and how do their average ratings and costs compare?
* **Key Findings/Insights:**
    * "North Indian" (17,549 restaurants) and "Chinese" (13,250 restaurants) are overwhelmingly dominant, indicating high market saturation but also immense demand. Their average ratings are around 3.6.
    * Cuisines like "Microbrewery" (4.40 avg rating), "Fine Dining" (4.17), "Japanese" (4.26), "Malaysian" (4.31), and "Modern Indian" (4.30) consistently achieve higher average ratings, often correlating with higher average costs. These represent premium or niche markets with high customer satisfaction.
    * "Quick Bites" (14,255 restaurants) and "Fast Food" (6,589 restaurants) are high-volume, low-cost segments with average ratings around 3.5-3.6, reflecting a focus on affordability and convenience.
* **Business Implications/Recommendations:**
    * **Market Strategy:** Zomato can identify highly competitive, mature markets (e.g., North Indian) versus less saturated, high-potential niche markets (e.g., Japanese, Modern Indian). This informs strategic growth areas.
    * **Restaurant Positioning:** New restaurants can use this to position themselves: compete on volume/price in saturated markets, or focus on quality/niche in less saturated, higher-rated segments.
    * **Targeted Promotions:** Highlight high-rated niche cuisines to users seeking unique or premium experiences.
* [View SQL Query](scripts/sql/cuisine_popularity_performance.sql)

#### **Problem 3: Impact of Online Ordering and Table Booking on Restaurant Success**

* **Business Question:** Does offering online ordering or table booking significantly impact a restaurant's average rating or its prevalence in the market?
* **Key Findings/Insights:**
    * Restaurants offering **Table Booking** (regardless of online order status) consistently achieve significantly higher average ratings (4.13 - 4.16) compared to those without (3.55 - 3.65). This strongly suggests that table booking correlates with a higher perceived quality of the dining experience.
    * Online ordering is highly prevalent (over 27,000 restaurants) but, by itself, does not directly lead to higher ratings. It appears to be a baseline expectation for convenience.
* **Business Implications/Recommendations:**
    * **For Zomato's Partner Success Team:** Actively encourage and support restaurants in implementing table booking features, emphasizing its direct correlation with higher customer satisfaction and potentially better ratings.
    * **For Restaurants:** Prioritize enhancing the dine-in experience and offering table booking as a key differentiator for quality perception. Online ordering is a necessity for reach, but not a primary quality driver.
* [View SQL Query](scripts/sql/service_impact_analysis.sql)

#### **Problem 4: Geographical Analysis - Hotspots & Underserved Areas**

* **Business Question:** Where are restaurants most concentrated (hotspots) in Bangalore? Are there areas with high density but low ratings (over-saturation/quality issues), or areas with high demand/ratings but fewer options (underserved markets)?
* **Key Findings/Insights:**
    * **Dominant Hotspots:** Localities like BTM (3,929 restaurants), Koramangala 5th Block (2,319), HSR (2,019), and Indiranagar (1,847) are major restaurant hubs.
    * **High Quality & Density:** Koramangala 5th Block (Avg Rating 4.01) stands out as a vibrant area balancing high density with strong customer satisfaction.
    * **High Density, Lower Rating:** BTM (Avg Rating 3.57) and Marathahalli (3.54) have very high restaurant counts but relatively lower average ratings, suggesting intense competition or a more value-driven market where quality might be inconsistent.
    * **Premium Pockets:** Localities like Lavelle Road (Avg Rating 4.14, Avg Cost ₹1365) and St. Marks Road (Avg Rating 4.02) indicate concentrations of higher-rated, more expensive establishments.
* **Business Implications/Recommendations:**
    * **For Zomato's Sales & Marketing:** Tailor strategies for each locality. In high-density, lower-rated areas, focus on quality improvement initiatives or highlighting value. In high-quality hotspots, emphasize unique offerings and premium experiences.
    * **For New Restaurant Ventures:** Provides crucial market intelligence for location scouting, advising on areas to avoid (high saturation, low ratings) or explore (balanced demand/quality, emerging premium zones).
* [View SQL Query](scripts/sql/locality_performance_density.sql)

#### **Problem 5: Cost vs. Rating Analysis (Value for Money)**

* **Business Question:** What is the relationship between the average cost of a meal for two and customer rating? Can high quality be found at lower price points?
* **Key Findings/Insights:**
    * A strong, positive correlation exists: as the average cost increases, so does the average rating. "Luxury (₹1500+)" restaurants boast the highest average rating (4.16), while "Budget (< ₹300)" restaurants average 3.56. This indicates customers generally perceive higher quality with higher prices.
    * The "Mid-Range (₹300 - ₹699)" segment has the largest volume of restaurants (21,915) and significant total votes (4M+), representing the mass market.
    * The "Premium (₹700 - ₹1499)" segment, while having fewer restaurants (9,507) than Mid-Range, garnered the highest total votes (6.6M+), suggesting high engagement and popularity within this price bracket.
* **Business Implications/Recommendations:**
    * **Targeted User Recommendations:** Zomato can provide highly relevant recommendations based on user budget, with clear expectations of quality.
    * **Pricing Strategy for Restaurants:** Reinforces that investing in quality and charging appropriately tends to be rewarded with higher customer satisfaction. It also highlights the high engagement in the "Premium" segment, which could be a target for new concepts.
* [View SQL Query](scripts/sql/cost_vs_rating_analysis.sql)

#### **Problem 6: Restaurant Type Performance & Distribution**

* **Business Question:** How do different restaurant types (e.g., Casual Dining, Cafe, Quick Bites) perform in terms of average rating and cost? Which types are most prevalent, and which offer a higher-quality experience?
* **Key Findings/Insights:**
    * **Volume Leaders:** "Quick Bites" (14,255 restaurants) and "Casual Dining" (11,303 restaurants) dominate the market in terms of sheer numbers. Quick Bites are low-cost (₹329) with a 3.55 average rating, while Casual Dining is mid-cost (₹856) with a 3.80 average.
    * **Highest Quality Types:** "Microbrewery" (4.40 avg rating), "Fine Dining" (4.17), "Pub" (4.10), and "Club" (4.05) consistently achieve the highest average ratings, often at a higher average cost, indicating a focus on premium experiences.
    * **Value Types:** "Cafe" (3.87 avg rating, ₹642 avg cost) and "Dessert Parlor" (3.88 avg rating, ₹360 avg cost) offer good quality at moderate or lower price points.
* **Business Implications/Recommendations:**
    * **Zomato's Platform Strategy:** Tailor search filters and featured collections by restaurant type (e.g., "Top Cafes for a Quick Meet," "Best Pubs for a Night Out").
    * **Restaurant Development:** Guides entrepreneurs on business models. High-volume types require efficiency; high-rated types demand focus on experience and quality.
* [View SQL Query](scripts/sql/restaurant_type_performance.sql)

#### **Problem 7: Restaurant Distribution Across Cities**

* **Business Question:** How are restaurants distributed across the different cities (or major localities treated as cities in the dataset)? Which cities have the most restaurants, and how do their average ratings and costs compare?
* **Key Findings/Insights:**
    * The restaurant market is heavily concentrated in certain "cities" (major localities within Bangalore), with different blocks of **Koramangala** (7th, 4th, 5th, 6th blocks) and **BTM** leading in restaurant count (2,000+ each).
    * Average ratings across most "cities" range from 3.5 to 3.8, with some upscale areas like **MG Road** (3.80 avg rating, ₹830 avg cost) and **Lavelle Road** (3.78 avg rating, ₹1365 avg cost) showing slightly higher quality and cost.
    * Lower-rated, high-volume areas like **Electronic City** (3.49 avg rating) suggest a more budget-focused market or areas with higher competition.
* **Business Implications/Recommendations:**
    * **Strategic Market Focus:** Zomato can allocate sales, marketing, and operational resources based on market density and quality profiles of these "cities."
    * **Expansion & Investment:** Provides a high-level overview for potential market expansion or investment decisions, highlighting areas with established dining scenes versus those with room for growth or quality improvement.
* [View SQL Query](scripts/sql/city_distribution_performance.sql)
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

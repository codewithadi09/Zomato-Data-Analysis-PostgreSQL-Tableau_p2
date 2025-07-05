# Zomato-Data-Analysis-PostgreSQL-Tableau_p2
Zomato Restaurant Data Analytics Project: End-to-end data analysis project, transforming raw, unstructured Zomato data into a normalized PostgreSQL database for advanced SQL querying and business intelligence visualization.
# Zomato Bangalore Restaurants: Data Modernization & Business Insights Project

This project showcases an end-to-end data analytics workflow, transforming raw, complex Zomato restaurant data into actionable business intelligence. My focus was on solving real-world challenges faced by a food delivery platform or restaurant chain, leveraging **PostgreSQL** for robust data engineering and **Microsoft Power BI** for insightful visualization.

---

## **Project Phases (Current Progress: Phase 1 Complete!)**

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

**Business Problems to Solve:**
* **Performance Benchmarking:** Identifying top-performing restaurants based on ratings, votes, and customer engagement to inform marketing strategies or partnership opportunities.
* **Market Opportunity Identification:** Analyzing restaurant density and cuisine popularity by locality and city to pinpoint underserved areas or saturated markets for new ventures.
* **Operational Efficiency:** Understanding the impact of features like online ordering and table booking on restaurant success metrics.
* **Customer Preference Trends:** Discovering popular cuisine types and cost segments to guide menu development or promotional campaigns.

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

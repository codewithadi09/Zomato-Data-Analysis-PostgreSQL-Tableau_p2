-- 1. Cities Table
CREATE TABLE cities (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(100) UNIQUE NOT NULL
);


-- 2. Localities Table (depends on cities)
CREATE TABLE localities (
    locality_id SERIAL PRIMARY KEY,
    locality_name VARCHAR(255) UNIQUE NOT NULL,
    city_id INT NOT NULL,
    FOREIGN KEY (city_id) REFERENCES cities(city_id)
);


-- 3. Cuisines Table
CREATE TABLE cuisines (
    cuisine_id SERIAL PRIMARY KEY,
    cuisine_name VARCHAR(100) UNIQUE NOT NULL
);


-- 4. Restaurant Types Table
CREATE TABLE restaurant_types (
    restaurant_type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(100) UNIQUE NOT NULL
);


-- 5. Restaurants Table (main table, depends on localities, cities, restaurant_types)
CREATE TABLE restaurants (
    restaurant_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    locality_id INT,
    city_id INT,
    online_order BOOLEAN,
    book_table BOOLEAN,
    cost_for_two NUMERIC(10, 2), -- Will parse from approx_cost
    zomato_url TEXT,
    phone TEXT,
    restaurant_type_id INT, -- Single type for now; multiple types would need a junction table
    rate NUMERIC(3,1), -- Parsed from 'rate' (e.g., 3.5)
    votes INT, -- Parsed from 'votes'
    listed_in_type VARCHAR(100), -- Original listed type string (for reference)
    listed_in_city VARCHAR(100), -- Original listed city string (for reference)
    FOREIGN KEY (locality_id) REFERENCES localities(locality_id),
    FOREIGN KEY (city_id) REFERENCES cities(city_id),
    FOREIGN KEY (restaurant_type_id) REFERENCES restaurant_types(restaurant_type_id)
);


-- Re-creating Restaurants Table with TEXT data types for potentially long string columns
CREATE TABLE restaurants (
    restaurant_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL, -- Changed from VARCHAR(255) to TEXT
    address TEXT,
    locality_id INT,
    city_id INT,
    online_order BOOLEAN,
    book_table BOOLEAN,
    cost_for_two NUMERIC(10, 2),
    zomato_url TEXT,
    phone TEXT,
    restaurant_type_id INT,
    rate NUMERIC(3,1),
    votes INT,
    listed_in_type TEXT, -- Changed from VARCHAR(100) to TEXT
    listed_in_city TEXT, -- Changed from VARCHAR(100) to TEXT
    FOREIGN KEY (locality_id) REFERENCES localities(locality_id),
    FOREIGN KEY (city_id) REFERENCES cities(city_id),
    FOREIGN KEY (restaurant_type_id) REFERENCES restaurant_types(restaurant_type_id)
);


-- 6. Restaurant Cuisines (Junction Table for Many-to-Many relationship)
CREATE TABLE restaurant_cuisines (
    restaurant_id INT NOT NULL,
    cuisine_id INT NOT NULL,
    PRIMARY KEY (restaurant_id, cuisine_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
    FOREIGN KEY (cuisine_id) REFERENCES cuisines(cuisine_id)
);


-- 7. Reviews Table (depends on restaurants and users)
CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL,
    user_id INT,
    rating NUMERIC(3,1),
    review_text TEXT,
    review_date DATE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


-- 8. Users Table (we might only get user_id or a general anonymous user for reviews)
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(255) UNIQUE -- We don't have real user names, so we'll likely generate anonymous users
);



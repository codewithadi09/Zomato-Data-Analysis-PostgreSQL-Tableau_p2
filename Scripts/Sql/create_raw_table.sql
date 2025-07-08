DROP TABLE IF EXISTS zomato_raw; 

CREATE TABLE zomato_raw (
    url TEXT,
    address TEXT,
    name TEXT,
    online_order TEXT,
    book_table TEXT,
    rate TEXT,
    votes TEXT,
    phone TEXT,
    location TEXT,
    rest_type TEXT,
    dish_liked TEXT,
    cuisines TEXT,
    "approx_cost(for two people)" TEXT,
    reviews_list TEXT,
	menu_item TEXT,
    "listed_in(type)"TEXT,
    "listed_in(city)" TEXT
);

SELECT * FROM zomato_raw;

SELECT COUNT(*) FROM zomato_raw; 
SELECT * FROM zomato_raw LIMIT 10; 

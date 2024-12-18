USE sakila;

#1.List the number of films per category
SELECT 
    name, 
    COUNT(*) AS film_count
FROM 
    film
JOIN 
    film_category ON film.film_id = film_category.film_id
JOIN 
    category ON film_category.category_id = category.category_id
GROUP BY 
    name
ORDER BY 
    film_count DESC;

#2.Retrieve the store ID, city, and country for each store.
SELECT 
    s.store_id, 
    c.city, 
    co.country
FROM 
    store s
JOIN 
    address a ON s.address_id = a.address_id
JOIN 
    city c ON a.city_id = c.city_id
JOIN 
    country co ON c.country_id = co.country_id;
    
#3.Calculate the total revenue generated by each store in dollars.
SELECT 
    s.store_id,
    SUM(p.amount) AS total_revenue
FROM 
    store s
JOIN 
    customer c ON s.store_id = c.store_id
JOIN 
    payment p ON c.customer_id = p.customer_id
GROUP BY 
    s.store_id;

#4.Determine the average running time of films for each category.
SELECT 
    c.name AS category_name,
    AVG(f.length) AS average_running_time
FROM 
    film f
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
GROUP BY 
    c.category_id, c.name
ORDER BY 
    average_running_time DESC;

#5.Identify the film categories with the longest average running time.
SELECT 
    c.name AS category_name,
    AVG(f.length) AS average_running_time
FROM 
    film f
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
GROUP BY 
    c.category_id, c.name
ORDER BY 
    average_running_time DESC
LIMIT 1;

#6.Display the top 10 most frequently rented movies in descending order.
SELECT 
    f.title AS film_title,
    COUNT(r.rental_id) AS rental_count
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
GROUP BY 
    f.film_id, f.title
ORDER BY 
    rental_count DESC
LIMIT 10;

#7.Determine if "Academy Dinosaur" can be rented from Store 1. 
SELECT 
    f.title,
    i.inventory_id,
    i.store_id,
    CASE 
        WHEN r.rental_date IS NULL THEN 'Available'
        ELSE 'Rented'
    END AS availability
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
LEFT JOIN 
    rental r ON i.inventory_id = r.inventory_id 
             AND r.return_date IS NULL
WHERE 
    f.title = 'Academy Dinosaur' 
    AND i.store_id = 1;

#8.Provide a list of all distinct film titles, along with their availability status in the inventory. Include a column indicating whether each title is 'Available' or 'NOT available.' Note that there are 42 titles that are not in the inventory, and this information can be obtained using a CASE statement combined with IFNULL."
SELECT 
    f.title AS film_title,
    CASE
        WHEN IFNULL(i.inventory_id, 0) = 0 THEN 'NOT available'  
        WHEN r.rental_id IS NULL THEN 'Available'                  
        ELSE 'NOT available'                                       
    END AS availability_status
FROM 
    film f
LEFT JOIN 
    inventory i ON f.film_id = i.film_id                        
LEFT JOIN 
    rental r ON i.inventory_id = r.inventory_id AND r.return_date IS NULL 
GROUP BY 
    f.title;





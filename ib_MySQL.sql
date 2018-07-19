-- Inna Baloyan - MySQL Assignment
-- Use sakila database

USE sakila;

-- 1a. Display the first and last names of all actors from the table `actor`.
SELECT 
    first_name, last_name
FROM
    sakila.actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. 
--     Name the column `Actor Name`.
SELECT 
    CONCAT(UPPER(first_name), ' ', UPPER(last_name)) AS 'Actor Name'
FROM
    sakila.actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT 
    actor_id AS 'ID number', first_name, last_name
FROM
    sakila.actor
WHERE
    first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters `GEN`:
SELECT 
    first_name, last_name
FROM
    sakila.actor
WHERE
    last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters `LI`. 
-- This time, order the rows by last name and first name, in that order:
SELECT 
    first_name, last_name
FROM
    sakila.actor
WHERE
    last_name LIKE '%LI%'
ORDER BY last_name , first_name;

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: 
-- Afghanistan, Bangladesh, and China:
SELECT 
    country_id, country
FROM
    sakila.country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');

-- 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. 
-- Hint: you will need to specify the data type.
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `middle_name` VARCHAR(45) NULL AFTER `first_name`;


-- 3b. You realize that some of these actors have tremendously long last names. 
-- Change the data type of the `middle_name` column to `blobs`.
ALTER TABLE `sakila`.`actor` 
CHANGE COLUMN `middle_name` `middle_name` BLOB NULL DEFAULT NULL;

-- 3c. Now delete the `middle_name` column.
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `middle_name`;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT 
    last_name, COUNT(last_name)
FROM
    sakila.actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
SELECT 
    last_name, COUNT(last_name)
FROM
    sakila.actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;

-- 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table 
-- as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. 
-- Write a query to fix the record.

-- Check what actor_id GROUCHO WILLIMS have
SELECT 
    first_name, last_name, actor_id
FROM
    sakila.actor
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';
-- id = 172

UPDATE sakila.actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';

-- Check if it worked - YES, it did
SELECT 
    first_name, last_name, actor_id
FROM
    sakila.actor
WHERE
    first_name = 'HARPO'
        AND last_name = 'WILLIAMS';
-- id = 172

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was 
-- the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, 
-- change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly 
-- what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR
-- TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)

/* SELECT 
    *
FROM
    sakila.actor
WHERE
    first_name = 'HARPO';
-- actor_id = 172

SELECT 
    *
FROM
    sakila.actor
WHERE
    first_name = 'HARPO'
        AND actor_id IN (SELECT 
            actor_id
        FROM
            sakila.actor
        WHERE
            first_name = 'HARPO'
                AND last_name = 'WILLIAMS');
*/    
UPDATE sakila.actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO' AND actor_id = 172;

-- Check if it worked 
select * from sakila.actor
where actor_id = 172;

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
-- Hint: <https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html>

SHOW CREATE TABLE sakila.address ;
-- results
/* address	CREATE TABLE `address` (
   `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
   `address` varchar(50) NOT NULL,
   `address2` varchar(50) DEFAULT NULL,
   `district` varchar(20) NOT NULL,
   `city_id` smallint(5) unsigned NOT NULL,
   `postal_code` varchar(10) DEFAULT NULL,
   `phone` varchar(20) NOT NULL,
   `location` geometry NOT NULL,
   `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`address_id`),
   KEY `idx_fk_city_id` (`city_id`),
   SPATIAL KEY `idx_location` (`location`),
   CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8
*/
-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
-- Use the tables `staff` and `address`:
SELECT 
    s.first_name, s.last_name, a.address, a.address2
FROM
    sakila.staff s
        JOIN
    sakila.address a ON a.address_id = s.address_id;

-- Just see how many staff members are there 
SELECT 
    s.first_name, s.last_name, s.address_id
FROM
    sakila.staff s;
-- 2

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
-- Use tables `staff` and `payment`.
SELECT 
    SUM(p.amount), p.staff_id
FROM
    sakila.payment p
        JOIN
    sakila.staff s ON (p.staff_id = s.staff_id)
WHERE
    p.payment_date BETWEEN CONVERT( '2005-08-01' , DATETIME) AND CONVERT( '2005-08-31' , DATETIME)
GROUP BY s.staff_id;

-- select convert("2005-08-01", DATETIME )

-- 6c. List each film and the number of actors who are listed for that film. 
-- Use tables `film_actor` and `film`. Use inner join.
SELECT 
    f.title, COUNT(fa.actor_id)
FROM
    sakila.film f
        INNER JOIN
    sakila.film_actor fa ON (f.film_id = fa.film_id)
GROUP BY f.title;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT 
    f.title, COUNT(i.inventory_id)
FROM
    sakila.inventory i,
    sakila.film f
WHERE
    i.film_id = f.film_id
        AND f.title = 'Hunchback Impossible';
-- 6
					
-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, 
-- list the total paid by each customer. List the customers alphabetically by last name:
SELECT 
    c.first_name,
    c.last_name,
    SUM(p.amount) AS 'Total Amount Paid'
FROM
    sakila.customer c
        INNER JOIN
    sakila.payment p ON (c.customer_id = p.customer_id)
GROUP BY c.last_name
ORDER BY c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity.
-- Use subqueries to display the titles of movies starting with the letters `K` and `Q` 
-- whose language is English.
SELECT 
    f1.title
FROM
    sakila.film f1
WHERE
    (f1.title LIKE 'K%' OR f1.title LIKE 'Q%')
        AND f1.language_id IN (SELECT 
            l.language_id
        FROM
            sakila.language l
        WHERE
            l.name = 'English');

-- select * from sakila.film
-- select * from sakila.language

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT 
    a.first_name, a.last_name
FROM
    sakila.actor a,
    sakila.film_actor fa
WHERE
    a.actor_id = fa.actor_id
        AND fa.film_id IN (SELECT 
            fa2.film_id
        FROM
            sakila.film_actor fa2,
            sakila.film f
        WHERE
            fa2.film_id = f.film_id
                AND f.title = 'Alone Trip');

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names 
-- and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT 
    c.first_name, c.last_name, c.email
FROM
    sakila.customer c
        JOIN
    sakila.address a ON (c.address_id = a.address_id)
        JOIN
    sakila.city ct ON (a.city_id = ct.city_id)
        JOIN
    sakila.country cn ON (ct.country_id = cn.country_id)
WHERE
    cn.country = 'Canada';

-- select * from sakila.country

-- 7d. Sales have been lagging among young families, and you wish to target all family movies 
-- for a promotion. Identify all movies categorized as family films.

-- select * from sakila.category
-- Family 8

SELECT 
    ft.title
FROM
    sakila.film_text ft
        JOIN
    sakila.film_category fc ON (ft.film_id = fc.film_id)
        JOIN
    sakila.category c ON (fc.category_id = c.category_id)
WHERE
    c.name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT 
	ft.title, COUNT(r.rental_date) AS 'How Often Rented'
FROM
	sakila.rental r
		JOIN
	sakila.inventory i ON (r.inventory_id = i.inventory_id)
		JOIN
	sakila.film_text ft ON (i.film_id = ft.film_id)
GROUP BY 1
ORDER by 2 desc;


-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT 
    s.store_id, SUM(p.amount) AS 'Gross'
FROM
    sakila.payment p
        JOIN
    sakila.customer c ON (p.customer_id = c.customer_id)
        JOIN
    sakila.store s ON (c.store_id = s.store_id)
GROUP BY s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT 
    s.store_id, ct.city, cn.country
FROM
    sakila.store s
        JOIN
    sakila.address a ON (s.address_id = a.address_id)
        JOIN
    sakila.city ct ON (a.city_id = ct.city_id)
		JOIN
	sakila.country cn ON ( ct.country_id = cn.country_id );

-- 7h. List the top five genres in gross revenue in descending order. 
-- (**Hint**: you may need to use the following tables: 
-- category, film_category, inventory, payment, and rental.)
SELECT 
	c.name, SUM(p.amount) AS 'Gross'
FROM
	sakila.payment p
		JOIN
	sakila.rental r ON ( p.rental_id = r.rental_id )
		JOIN
	sakila.inventory i ON (r.inventory_id = i.inventory_id)
		JOIN
	sakila.film_category fc ON (i.film_id = fc.film_id)
		JOIN
	sakila.category c ON ( fc.category_id = c.category_id )
GROUP BY 1
ORDER BY 2 desc
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing 
-- the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW sakila.top_five_genres AS
    (SELECT 
        c.name, SUM(p.amount) AS 'Gross'
    FROM
        sakila.payment p
            JOIN
        sakila.rental r ON (p.rental_id = r.rental_id)
            JOIN
        sakila.inventory i ON (r.inventory_id = i.inventory_id)
            JOIN
        sakila.film_category fc ON (i.film_id = fc.film_id)
            JOIN
        sakila.category c ON (fc.category_id = c.category_id)
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 5);

-- 8b. How would you display the view that you created in 8a?

SELECT 
    *
FROM
    sakila.top_five_genres;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

drop view if exists sakila.top_five_genres;

-- The End
USE sakila;
SELECT *
FROM inventory;
#Lab, SQL Subqueries 3.03 task 
#8 queries 

#In this lab, you will be using the Sakila database of movie rentals. Create appropriate joins wherever necessary.

#Instructions
# 1 How many copies of the film Hunchback Impossible exist in the inventory system?
# 2 List all films whose length is longer than the average of all the films.
#Use subqueries to display all actors who appear in the film Alone Trip.
#Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
#5 Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
#Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
#Films rented by most profitable customer (the customer who has spent the most money, max sum amounts per customer). You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
#Customers who spent more than the average payments (1st average payment per customer and all the customer who has spent more than that,  a customer has maid).

# 1 How many copies of the film Hunchback Impossible exist in the inventory system?
# inventory id count for one movies
# then 
select title as film_name, count(inventory_id) as film_copies
from inventory
join film
using(film_id)
where title = 'Hunchback Impossible'
group by title; 

# 2 List all films whose length is longer than the average of all the films.
# use table film 
# use table film duration of all films 
# join here film and length  
# length is the duration

select *
from film
where length > (select avg(length)
from film);

# 3 Use subqueries to display all actors who appear in the film Alone Trip.
SELECT *
FROM actor;

SELECT first_name, last_name, title as film_name
FROM actor
JOIN film_actor
USING(actor_id)
JOIN film
USING(film_id)
WHERE film_id = 
(SELECT film_id
FROM film WHERE title = 'Alone Trip');

# 4 Sales have been lagging among young families, and you wish to target all 
# family movies for a promotion. Identify all movies categorized as family films.

select name as category, title
from film
join film_category
using(film_id)
join category
using(category_id)
where category_id =  (select category_id from category where name = 'Family');

# 5 Get name and email from customers from Canada(country_id=20) using subqueries. 
# Do the same with joins. Note that to create a join, you will have to identify 
#the correct tables with their primary keys and foreign keys, 
#that will help you get the relevant information.
SELECT * FROM sakila.customer;
SELECT * FROM sakila.city;
SELECT * FROM sakila.address; # 
SELECT * FROM sakila.country; # canada 20
# relationship customer and address

select first_name, last_name, email
from customer c
join address a
using(address_id)
where city_id IN  
(
select city_id from city
where country_id = (select country_id from country where country = 'Canada')
);

#  6 Which are films starred by the most prolific actor? 
#Most prolific actor is defined as the actor that 
# has acted in the most number of films. First you will have to find the most
# prolific actor and then 
# # use that actor_id to find the different films that he/she starred.
# prolific = produktiv
SELECT * FROM sakila.film;
SELECT * FROM sakila.actor;

select actor_id, title as film_name
from film
join film_actor
using (film_id)
where actor_id = 
(select actor_id
from film_actor
group by actor_id
order by count(film_id) desc
limit 1);


# 7 Films rented by most profitable customer (the customer who has spent 
#the most money, max sum amounts per customer). 
#You can use the customer table and payment table to find the 
#most profitable customer ie the customer that has made the 
#largest sum of payments
# Customers who spent more than the average payments 
#(1st average payment per customer and all the customer who has 
#spent more than that,  a customer has maid).

select distinct title as film_name
from film
join inventory
using(film_id)
join rental
using(inventory_id)
where customer_id =
(select customer_id
from payment
group by customer_id
order by sum(amount) desc
limit 1);

# 8 Customers who spent more than the average payments 
#(1st average payment per customer and 
# # all the customer who has spent more than that,  
#a customer has maid).

select first_name, last_name, email
from customer
where customer_id IN 
( select customer_id
from payment
group by customer_id
having sum(amount) >
(select avg(amount) as avg_pay
from payment) ) ;

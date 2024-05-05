USE sakila;

-- Lab Temporary Tables, Views and CTEs
-- Challenge: Creating a Customer Summary Report
-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW customer_rental_summary AS
SELECT c.customer_id,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
c.email,
COUNT(r.rental_id) AS rental_count
FROM customer AS c
LEFT JOIN rental AS r 
ON c.customer_id = r.customer_id
GROUP BY c.customer_id;


-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE total_paid_by_customer AS
SELECT p.customer_id,
SUM(amount) AS total_paid
FROM payment AS p
LEFT JOIN customer_rental_summary AS crs
ON p.customer_id = crs.customer_id
GROUP BY p.customer_id;


-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.
WITH customer_summary_cte AS (
    SELECT 
        crs.customer_name,
        crs.email,
        crs.rental_count,
        tpbc.total_paid,
        tpbc.total_paid / crs.rental_count AS average_payment_per_rental
    FROM 
        customer_rental_summary AS crs
    LEFT JOIN total_paid_by_customer AS tpbc 
	ON crs.customer_id = tpbc.customer_id
)
SELECT 
    customer_name,
    email,
    rental_count,
    total_paid,
    average_payment_per_rental
FROM 
    customer_summary_cte;


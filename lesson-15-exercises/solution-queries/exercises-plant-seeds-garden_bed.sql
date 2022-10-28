--   2.4. Exercises: The SQL Sequel  --

-- Create plant table --
CREATE TABLE plant (
plant_id INTEGER PRIMARY KEY AUTO_INCREMENT,
plant_name VARCHAR (40),
zone INTEGER,
season ENUM ("Spring", "Summer", "Fall", "Winter")
);

-- Verify plant table --
SELECT * FROM plant;

-- Create seeds table --
CREATE TABLE seeds (
seed_id INTEGER PRIMARY KEY AUTO_INCREMENT,
expiration_date DATE,
quantity INTEGER,
reorder BOOL,
plant_id INTEGER,
FOREIGN KEY (plant_id) REFERENCES plant (plant_id)
);

-- Verify seeds table --
SELECT * FROM seeds;

-- Create garden_bed table --
CREATE TABLE garden_bed (
space_number INTEGER PRIMARY KEY AUTO_INCREMENT,
date_planted DATE,
doing_well BOOL,
plant_id INTEGER,
FOREIGN KEY (plant_id) REFERENCES plant (plant_id)
);

-- Verify garden_bed table --
SELECT * FROM garden_bed;

-- 2.4.3. Try Out Some Joins! --

-- Inner Join: Use an inner join on seeds and garden_bed to see which plants we have seeds for and are in our garden bed.-- 
SELECT *
FROM seeds
INNER JOIN garden_bed ON (seeds.plant_id = garden_bed.plant_id); 

-- Left Join: Join seeds and garden_bed with a left join to see all of the seeds we have and any matching plants in the garden bed. --
SELECT *
FROM seeds
LEFT JOIN garden_bed ON (seeds.plant_id = garden_bed.plant_id);

-- Right Join: Write a query that joins seeds and garden_bed with a right join to see all the plants in the garden bed and any matching seeds we have.--
SELECT *
FROM seeds
RIGHT JOIN garden_bed ON (seeds.plant_id = garden_bed.plant_id);

-- Full Join: Write a query that joins seeds and garden_bed with a full join. --
-- Note: There are no full joins in mysql, so need to do a left and right with UNION keyword inbetween. --
SELECT *
FROM seeds
LEFT JOIN garden_bed ON (seeds.plant_id = garden_bed.plant_id)
UNION
SELECT *
FROM seeds
RIGHT JOIN garden_bed ON (seeds.plant_id = garden_bed.plant_id);

-- Sub-Queries 1: Write a query that gets the name of the plant by joining the plant table on the result set of the inner join query above. -- 
-- I don't understand this solution. The book never discussed the error received w/o the AS clause blow "Error Code: 1248. Every derived table must have its own alias" --
-- Per MySql Doc: A derived table is an expression that generates a table within the scope of a query FROM clause. For example, a subquery in a SELECT statement FROM clause is a derived table: SELECT ... FROM (subquery) [AS] tbl_name ... The [AS] tbl_name clause is mandatory because every table in a FROM clause must have a name. --
SELECT plant_name 
FROM plant 
INNER JOIN (SELECT seeds.plant_id FROM seeds INNER JOIN garden_bed ON seeds.plant_id=garden_bed.plant_id) AS planted_plants ON plant.plant_id=planted_plants.plant_id;

-- Sub-Queries 2: Write a query that will insert a new row into our seeds table. See details in Chptr 2.4.4.2. -- 
INSERT INTO seeds (expiration_date, quantity, reorder, plant_id)
VALUES ('2020-05-08', 100, 0, (SELECT plant_id FROM plant WHERE (plant_name LIKE 'Hosta')));

-- Verify New Row Added -- 
SELECT * FROM seeds;

-- Verify plant_id is correct from plant table --
SELECT * FROM plant;

-- BONUS MISSION 1: Revisit/Copy your query with a full join above and try using UNION ALL as opposed to UNION. How does the result set differ?-- 
-- UNION: keeps only unique records. -- 
-- UNION ALL: keeps all records, including duplicates. -- 
SELECT *
FROM seeds
LEFT JOIN garden_bed ON (seeds.plant_id = garden_bed.plant_id)
UNION ALL
SELECT *
FROM seeds
RIGHT JOIN garden_bed ON (seeds.plant_id = garden_bed.plant_id);

-- BONUS MISSION 2: Reuse query for getting the plant_name of plants that we have seeds for and are in the garden bed and use COUNT() to see how many plants are in both places. -- 
SELECT COUNT(plant_name)  
FROM plant 
INNER JOIN (SELECT seeds.plant_id FROM seeds INNER JOIN garden_bed ON seeds.plant_id=garden_bed.plant_id) AS planted_plants ON plant.plant_id=planted_plants.plant_id;


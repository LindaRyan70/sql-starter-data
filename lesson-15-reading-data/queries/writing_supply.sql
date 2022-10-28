-- MySQL Chptr 2.2 Database Mngmt Setup --

-- 2.2.1.1. writing_supply -- 

CREATE TABLE writing_supply (
supply_id INTEGER PRIMARY KEY AUTO_INCREMENT,
utensil_type ENUM ("Pencil", "Pen"),
num_drawers INTEGER
);

-- 2.2.1.2. pencil_drawer-- 

CREATE TABLE pencil_drawer (
drawer_id INTEGER PRIMARY KEY AUTO_INCREMENT,
pencil_type ENUM ("Wood", "Mechanical"),
quantity INTEGER,
refill BOOLEAN,
supply_id INTEGER,
FOREIGN KEY (supply_id) REFERENCES writing_supply (supply_id)
);

-- 2.2.1.3. pen_drawer--
 
CREATE TABLE pen_drawer (
drawer_id INTEGER PRIMARY KEY AUTO_INCREMENT,
color ENUM ("Black", "Blue", "Red", "Green", "Purple"),
quantity INTEGER,
refill BOOLEAN,
supply_id INTEGER,
FOREIGN KEY (supply_id) REFERENCES writing_supply (supply_id)
);

-- Confirm Data Imported from .csv files --

SELECT * FROM writing_supply;

SELECT * FROM pencil_drawer;

SELECT * FROM pen_drawer;


-- 2.3.1.1. Inner Join Review -- 

-- First Result set contains all records from both tables with matching supply_id values.-- 
SELECT *
FROM writing_supply
INNER JOIN pencil_drawer ON writing_supply.supply_id = pencil_drawer.supply_id;

-- Second Result set contains only the columns listed in the SELECT line that meet the WHERE conditions --
SELECT writing_supply.supply_id, pencil_type, drawer_id, quantity
FROM writing_supply
INNER JOIN pencil_drawer ON writing_supply.supply_id = pencil_drawer.supply_id
WHERE refill = true AND pencil_type = "Mechanical";

-- 2.3.1.2. Left/Right Join Review --
-- Use a LEFT or RIGHT join to retain all of the records from one table and pull in overlapping data from another. -- 

SELECT writing_supply.supply_id, utensil_type, drawer_id, color
FROM writing_supply
LEFT JOIN pen_drawer ON writing_supply.supply_id = pen_drawer.supply_id;

--  We can restrict the size of the result set by adding one or more conditions in a WHERE clause. --
SELECT writing_supply.supply_id, utensil_type, drawer_id, color, quantity
FROM writing_supply
LEFT JOIN pen_drawer ON writing_supply.supply_id = pen_drawer.supply_id
WHERE refill = true;

-- 2.3.1.3. Multiple Joins Review -- 

--  Left Join by itself -- 
SELECT writing_supply.supply_id, utensil_type, drawer_id, quantity 
FROM writing_supply
LEFT JOIN pencil_drawer ON writing_supply.supply_id = pencil_drawer.supply_id
WHERE refill = true;

--  Right Join by itself -- 
SELECT writing_supply.supply_id, utensil_type, drawer_id, quantity 
FROM writing_supply
RIGHT JOIN pen_drawer ON writing_supply.supply_id = pen_drawer.supply_id
WHERE refill = true;

-- Combining the above 2 queries at the same time with UNION keyword, and sorting results with ORDER BY at the end. --
SELECT writing_supply.supply_id, utensil_type, drawer_id, quantity 
FROM writing_supply
LEFT JOIN pencil_drawer ON writing_supply.supply_id = pencil_drawer.supply_id
WHERE refill = true
UNION
SELECT writing_supply.supply_id, utensil_type, drawer_id, quantity 
FROM writing_supply
RIGHT JOIN pen_drawer ON writing_supply.supply_id = pen_drawer.supply_id
WHERE refill = true
ORDER BY supply_id;

-- 2.3.2. Subqueries -- 

SELECT supply_id
FROM writing_supply
WHERE utensil_type = "Pen";

SELECT drawer_id, color 
FROM pen_drawer
WHERE quantity >= 60 AND supply_id = 5;

--  Nest the 1st query above inside the WHERE IN ( ) of the 2nd query above.  --
SELECT drawer_id, color 
FROM pen_drawer
WHERE supply_id IN (SELECT supply_id FROM writing_supply WHERE utensil_type = "Pen");

-- Restrict with an AND keyword. --
SELECT drawer_id, color 
FROM pen_drawer
WHERE supply_id IN (SELECT supply_id FROM writing_supply WHERE utensil_type = "Pen")
AND quantity >= 60;

-- Refactor with SELECT MAX (  ) in the WHERE clause below to just get data from the last writing_supply row that contains pens.  --
SELECT drawer_id, color 
FROM pen_drawer
WHERE supply_id = (SELECT MAX(supply_id) FROM writing_supply WHERE utensil_type = "Pen")
AND quantity >= 60;
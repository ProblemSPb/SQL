CREATE DATABASE companyHR;
USE companyHR;
CREATE TABLE co_employees (
	id INT  PRIMARY KEY AUTO_INCREMENT,
    em_name VARCHAR(255) NOT NULL,
    gender CHAR(1) NOT NULL,
    contact_number VARCHAR(255),
    age INT NOT NULL,
    date_created TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE mentorship (
	mentor_id INT NOT NULL,
    mentee_id INT NOT NULL,
    status VARCHAR(255) NOT NULL,
    project VARCHAR(255) NOT NULL,
    
    PRIMARY KEY (mentor_id, mentee_id, project),
    CONSTRAINT fkl FOREIGN KEY(mentor_id) REFERENCES co_employees(id) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT fk2 FOREIGN KEY(mentee_id) REFERENCES co_employees(id) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT mm_constraint UNIQUE(mentor_id, mentee_id)
);

RENAME TABLE co_employees TO employees;

ALTER TABLE employees
	DROP COLUMN age,
    ADD COLUMN salary FLOAT NOT NULL AFTER contact_number,
    ADD COLUMN years_in_company INT NOT NULL AFTER salary;
    
DESCRIBE employees;

ALTER TABLE mentorship
	DROP FOREIGN KEY fk2;
    
ALTER TABLE mentorship
	ADD CONSTRAINT fk2 FOREIGN KEY(mentee_id) REFERENCES employees(id) ON DELETE CASCADE ON UPDATE CASCADE,
    DROP INDEX mm_constraint;
    
INSERT INTO employees (em_name, gender, contact_number, salary, years_in_company) VALUES 
    ('James Lee', 'M', '516-514-6568', 3500, 11),
    ('Peter Pasternak', 'M', '845-644-7919', 6010, 10),
    ('Clara Couto', 'F', '845-641-5236', 3900, 8),
    ('Walker Welch', 'M', NULL, 2500, 4),
    ('Li Xiao Ting', 'F', '646-218-7733', 5600, 4),
    ('Joyce Jones', 'F', '523-172-2191', 8000, 3),
    ('Jason Cerrone', 'M', '725-441-7172', 7980, 2),
    ('Prudence Phelps', 'F', '546-312-5112', 11000, 2),
    ('Larry Zucker', 'M', '817-267-9799', 3500, 1),
    ('Serena Parker', 'F', '621-211-7342', 12000, 1);

INSERT INTO mentorship VALUES
(1, 2, 'Ongoing', 'SQF Limited'),
(1, 3, 'Past', 'Wayne Fibre'),
(2, 3, 'Ongoing', 'SQF Limited'),
(3, 4, 'Ongoing', 'SQF Limited'),
(6, 5, 'Past', 'Flynn Tech');

UPDATE employees
SET contact_number = '516-514-1729'
WHERE id = 1;

DELETE FROM employees
WHERE id = 5;

UPDATE employees
SET id = 11
WHERE id = 4;

SELECT * FROM employees;
SELECT * FROM mentorship;

SELECT em_name, gender FROM employees;
SELECT em_name AS 'Employee Name', gender AS 'Employee Gender' FROM employees;
SELECT em_name, gender FROM employees LIMIT 3;
SELECT DISTINCT(gender) FROM employees;

SELECT * FROM employees WHERE id != 1;
SELECT * FROM employees WHERE id BETWEEN 1 AND 3;

SELECT * FROM employees WHERE em_name LIKE '%er';
SELECT * FROM employees WHERE em_name LIKE '%er%';
SELECT * FROM employees WHERE em_name LIKE '____e%';

SELECT * FROM employees WHERE id IN (6, 7, 9);
SELECT * FROM employees WHERE id NOT IN (7, 8);

SELECT * FROM employees WHERE (years_in_company > 5 OR salary > 5000) AND gender = 'F';

/* subqueries */
SELECT em_name FROM employees WHERE id IN
(SELECT mentor_id FROM mentorship WHERE project = 'SQF Limited');

SELECT date_created FROM employees WHERE id IN
(SELECT mentor_id FROM mentorship WHERE status = 'past');

SELECT * FROM mentorship;

SELECT date_created FROM employees WHERE id IN
(SELECT mentor_id FROM mentorship WHERE mentor_id < 3);

SELECT * FROM employees ORDER BY gender, em_name;
SELECT * FROM employees ORDER BY gender DESC, em_name;

/* Functions */

SELECT concat('Hello', ' World');
SELECT substring('Programming', 2);
SELECT substring('Programming', 2, 6);
SELECT now();
SELECT curdate();
SELECT curtime();

/* Aggregate Functions */

# Comment
-- Commment

SELECT count(*) FROM employees;
SELECT count(*) FROM mentorship;

SELECT count(contact_number) FROM employees;
SELECT count(DISTINCT gender) FROM employees;

SELECT AVG(salary) FrOM employees;
SELECT round(AVG(salary), 2) FROM employees;

SELECT MAX(salary) FROM employees;
SELECT MIN(id) FROM employees;
SELECT SUM(salary) FROM employees;

SELECT gender, MAX(salary) FROM employees GROUP BY gender;

SELECT gender, MAX(salary) FROM employees GROUP BY gender HAVING MAX(salary) > 10000;

SELECT employees.id, mentorship.mentor_id, employees.em_name AS 'Mentor', mentorship.project AS 'Project Name'
FROM
mentorship
JOIN
employees
ON
employees.id = mentorship.mentor_id;

SELECT employees.em_name AS 'Mentor', mentorship.project AS 'Project Name'
FROM
mentorship
JOIN
employees
ON
employees.id = mentorship.mentor_id;

-- unions
-- union removes duplicates
-- union all keeps everything

SELECT em_name, salary FROM employees WHERE gender = 'M'
UNION
SELECT em_name, years_in_company FROM employees WHERE gender = 'F';

SELECT mentor_id FROM mentorship
UNION ALL
SELECT id FROM employees WHERE gender = 'F';

-- views
-- view is a virtual table

CREATE VIEW myView AS
SELECT employees.id, mentorship.mentor_id, employees.em_name AS 'Mentor',
mentorship.project AS 'Project Name'
FROM
mentorship
JOIN
employees
ON
employees.id = mentorship.mentor_id;

SELECT * FROM myView;

ALTER VIEW myView AS
SELECT employees.id, mentorship.mentor_id, employees.em_name AS 'Mentor', mentorship.project AS 'Project'
FROM mentorship
JOIN
employees
ON
employees.id = mentorship.mentor_id;

SELECT * FROM myView;

-- deleting a view
DROP VIEW IF EXISTS myView;

-- Triggers
-- actions activated when a defined event occurs for a specific table
-- event can be: INSERT, UPDATE or DELETE
-- trigger can be before or after an event

CREATE TABLE ex_employees (
em_id INT PRIMARY KEY,
em_name VARCHAR(255) NOT NULL,
gender CHAR(1) NOT NULL,
date_left TIMESTAMP DEFAULT NOW()
);

DELIMITER $$
CREATE TRIGGER update_ex_employees BEFORE DELETE ON employees FOR EACH ROW
BEGIN
	INSERT INTO ex_employees (em_id, em_name, gender) VALUES (OLD.id, OLD.em_name, OLD.gender);
END $$
DELIMITER ;

DELETE FROM employees WHERE id = 10;

SELECT * FROM employees;
SELECT * FROM ex_employees;

-- deleting a trigger
DROP TRIGGER IF EXISTS update_ex_employees;

-- 5 Jan 2020

SET @result = sqrt(9);
SELECT @result;

-- combining SET and SELECT
SELECT @result := sqrt(12);

-- stored routines (stored procedures and stored functions)
-- stored procedures
-- procedures are executed by using the CALL keyword
DELIMITER $$
CREATE PROCEDURE select_info()
BEGIN
	SELECT * FROM employees;
    SELECT * FROM mentorship;
END $$
DELIMITER ;

CALL select_info;

DELIMITER $$
CREATE PROCEDURE employee_info(IN p_em_id INT)
BEGIN
	SELECT * FROM mentorship WHERE mentor_id = p_em_id;
    SELECT * FROM mentorship WHERE mentee_id = p_em_id;
    SELECT * FROM employees WHERE id = p_em_id;
END $$
DELIMITER ;

CALL employee_info(1);

DELIMITER $$
CREATE PROCEDURE employee_name_gender(IN p_em_id INT, OUT p_name VARCHAR(255), OUT p_gender CHAR(1))
BEGIN
	SELECT em_name, gender INTO p_name, p_gender FROM employees WHERE id = p_em_id;
END $$
DELIMITER ;

-- we can pass the variables without declaring them, MySQL will declare them for us.
-- @v_name, @v_gender
CALL employee_name_gender(1, @v_name, @v_gender);

SELECT * FROM employees WHERE gender = @v_gender;

-- get mentor_id based on its mentee_id and project values
DELIMITER $$
CREATE PROCEDURE get_mentor(INOUT p_em_id INT, IN p_project VARCHAR(255))
BEGIN
	SELECT mentor_id INTO p_em_id FROM mentorship WHERE mentee_id = p_em_id AND project = p_project;
END $$

DELIMITER ;

SET @v_id = 3;

CALL get_mentor(@v_id, 'Wayne Fibre');

SELECT @v_id;

-- STORED FUNCTIONS
-- a stored function must return a value using the RETURN keyword.
-- executed by using SELECT statement

-- to calculate the bonus for employees
DELIMITER $$
CREATE FUNCTION calculateBonus(p_salary DOUBLE, p_multiple DOUBLE) RETURNS DOUBLE DETERMINISTIC
BEGIN
	DECLARE bonus DOUBLE(8, 2);
    SET bonus = p_salary*p_multiple;
    RETURN bonus;
END $$
DELIMITER ;

SELECT id, em_name, salary, calculateBonus(salary, 1.5) AS bonus FROM employees;

-- Deleting a stored function
DROP FUNCTION IF EXISTS calculateBonus;


--Jan 19
								    
-- Control flow Tools
-- IF statement

DELIMITER $$
CREATE FUNCTION if_demo(x INT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	IF x > 0 THEN RETURN 'x is positive';
    ELSEIF x = 0 THEN RETURN 'x is zero';
    ELSE RETURN 'x is negative';
	END IF;

END $$
DELIMITER ; 

SELECT if_demo(2);

DELIMITER $$
CREATE FUNCTION case_demo_A(x INT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	CASE x
		WHEN 1 THEN RETURN 'x is 1';
        WHEN 2 THEN RETURN 'x is 2';
        ELSE RETURN 'x is neither 1 nor 2';
	END CASE;
END $$
DELIMITER ;

SELECT case_demo_A(1);

DELIMITER $$
CREATE FUNCTION case_demo_B(x INT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	CASE
    WHEN x > 0 THEN RETURN 'x is positive';
    WHEN x = 0 THEN RETURN 'x is zero';
    ELSE RETURN 'x is negative';
    END CASE;
    
END $$
DELIMITER ;

SELECT case_demo_B(6);

-- WHILE statement

DELIMITER $$
CREATE FUNCTION while_demo(x INT, y INT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	DECLARE z VARCHAR(255);
	SET z = '';

	while_example: WHILE x<y DO
		SET x = x + 1;
		SET z = concat(z, x);
	END WHILE;

	RETURN z;
END $$
DELIMITER ;

SELECT while_demo(1, 5);
								    
-- REPEAT 
-- it will perform tasks at least ONCE. Always.

DELIMITER $$
CREATE FUNCTION repeat_demo(x INT, y INT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	DECLARE z VARCHAR(255);
    SET z = '';
    
    REPEAT
		SET x = x + 1;
        SET z = concat(z, x);
        UNTIL x>=y
        END REPEAT;
        
        RETURN z;
	END $$
    DELIMITER ;
    
SELECT repeat_demo(1, 5);

-- LOOP statement

DELIMITER $$
CREATE FUNCTION loop_demo_A(x INT, y INT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	DECLARE z VARCHAR(255);
    SET z = '';
    simple_loop: LOOP
		SET x = x + 1;
        IF x>y THEN
			LEAVE simple_loop;
		END IF;
        SET z = concat(z, x);
	END LOOP;
    
    RETURN z;
END $$
DELIMITER ;

SELECT loop_demo_A(1, 5);

-- LOOP with ITERATE
DELIMITER $$
CREATE FUNCTION loop_demo_B(x INT, y INT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	DECLARE z VARCHAR(255);
    SET z = '';
    
    simple_loop: LOOP
		SET x = x + 1;
        IF x = 3 THEN ITERATE simple_loop;
			ELSEIF x > y THEN LEAVE simple_loop;
		END IF;
        SET z = concat(z, x);
	END LOOP;
    
    RETURN z;
END $$
DELIMITER ;

SELECT loop_demo_B(1, 5);


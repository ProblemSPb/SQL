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

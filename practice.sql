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
    

CREATE TABLE student (
    student_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    department VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL
);

CREATE TABLE company (
    company_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    company_name VARCHAR(150) NOT NULL,
    industry VARCHAR(100) NOT NULL
);

CREATE TABLE internship (
    internship_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    company_id INTEGER NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    application_deadline DATE NOT NULL,
    capacity INTEGER,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    CONSTRAINT fk_internship_company
        FOREIGN KEY (company_id) REFERENCES company(company_id)
);

CREATE TABLE application (
    application_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INTEGER NOT NULL,
    internship_id INTEGER NOT NULL,
    application_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL,
    CONSTRAINT fk_application_student
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_application_internship
        FOREIGN KEY (internship_id) REFERENCES internship(internship_id)
);
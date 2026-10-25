\set VERBOSITY verbose

-- Testlerden önce tabloları temizleyip kimlik numaralarını sıfırla.
TRUNCATE TABLE application, internship, company, student RESTART IDENTITY CASCADE;

-- Testler için gerekli başlangıç verilerini ekle.
INSERT INTO student (full_name, email, department, city)
VALUES
('Ali Yilmaz', 'ali@example.com', 'MIS', 'Istanbul'),
('Ayse Demir', 'ayse@example.com', 'Engineering', 'Ankara');

INSERT INTO company (company_name, industry)
VALUES
('TechNova', 'technology'),
('FinCore', 'finance');

INSERT INTO internship
(company_id, title, description, application_deadline, capacity, start_date, end_date)
VALUES
(1, 'Software Intern', 'Software development internship', '2026-12-01', 5, '2026-11-01', '2026-11-30'),
(2, 'Finance Intern', 'Finance internship', '2026-12-05', 3, '2026-11-01', '2026-11-30');

INSERT INTO application (student_id, internship_id, application_date, status)
VALUES (1, 1, '2026-10-20', 'submitted');

-- TEST 1: uq_student_email ihlali; beklenen SQLSTATE 23505.
INSERT INTO student (full_name, email, department, city)
VALUES ('Duplicate Email', 'ali@example.com', 'MIS', 'Istanbul');

-- TEST 2: uq_student_internship ihlali; beklenen SQLSTATE 23505.
INSERT INTO application (student_id, internship_id, application_date, status)
VALUES (1, 1, '2026-10-21', 'reviewing');

-- TEST 3: uq_company_internship_title ihlali; beklenen SQLSTATE 23505.
INSERT INTO internship
(company_id, title, description, application_deadline, capacity, start_date, end_date)
VALUES
(1, 'Software Intern', 'Duplicate title', '2026-12-10', 2, '2026-11-01', '2026-11-30');

-- TEST 4: chk_internship_capacity ihlali; beklenen SQLSTATE 23514.
INSERT INTO internship
(company_id, title, application_deadline, capacity, start_date, end_date)
VALUES
(1, 'Invalid Capacity', '2026-12-10', 0, '2026-11-01', '2026-11-30');

-- TEST 5: chk_internship_dates ihlali; beklenen SQLSTATE 23514.
INSERT INTO internship
(company_id, title, application_deadline, capacity, start_date, end_date)
VALUES
(1, 'Invalid Dates', '2026-12-10', 2, '2026-11-30', '2026-11-01');

-- TEST 6: chk_application_status ihlali; beklenen SQLSTATE 23514.
INSERT INTO application (student_id, internship_id, application_date, status)
VALUES (2, 2, '2026-10-21', 'pending');

-- TEST 7: fk_application_student ihlali; beklenen SQLSTATE 23503.
INSERT INTO application (student_id, internship_id, application_date, status)
VALUES (999, 1, '2026-10-21', 'submitted');

-- TEST 8: fk_application_internship ihlali; beklenen SQLSTATE 23503.
INSERT INTO application (student_id, internship_id, application_date, status)
VALUES (2, 999, '2026-10-21', 'submitted');

-- TEST 9: Referans verilen şirket silinemez; beklenen SQLSTATE 23503.
DELETE FROM company WHERE company_id = 1;

-- TEST 10: student.city NOT NULL ihlali; beklenen SQLSTATE 23502.
INSERT INTO student (full_name, email, department, city)
VALUES ('Missing City', 'missing.city@example.com', 'MIS', NULL);

-- TEST 11: Sınır testi; kapasite 1 kabul edilmelidir (OK).
INSERT INTO internship
(company_id, title, application_deadline, capacity, start_date, end_date)
VALUES
(1, 'Capacity One', '2026-12-10', 1, '2026-11-15', '2026-11-30');

-- TEST 12: Sınır testi; başlangıç ve bitiş aynı gün olabilir (OK).
INSERT INTO internship
(company_id, title, application_deadline, capacity, start_date, end_date)
VALUES
(2, 'One Day Internship', '2026-12-10', 2, '2026-11-15', '2026-11-15');

-- TEST 13: CHECK koşulunda NULL kapasite kabul edilir (OK).
INSERT INTO internship
(company_id, title, application_deadline, capacity, start_date, end_date)
VALUES
(2, 'Unknown Capacity', '2026-12-10', NULL, '2026-11-01', '2026-11-30');
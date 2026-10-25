-- Önce tabloları temizle ve kimlik numaralarını sıfırla.
TRUNCATE TABLE application, internship, company, student RESTART IDENTITY CASCADE;

-- 6 öğrenci ekle.
INSERT INTO student (full_name, email, department, city) VALUES
('Ali Yilmaz', 'ali.yilmaz@example.com', 'Management Information Systems', 'Istanbul'),
('Ayse Demir', 'ayse.demir@example.com', 'Computer Engineering', 'Ankara'),
('Mehmet Kaya', 'mehmet.kaya@example.com', 'Industrial Engineering', 'Istanbul'),
('Zeynep Aydin', 'zeynep.aydin@example.com', 'Management Information Systems', 'Izmir'),
('Emre Celik', 'emre.celik@example.com', 'Computer Engineering', 'Ankara'),
('Elif Sahin', 'elif.sahin@example.com', 'Industrial Engineering', 'Istanbul');

-- 3 şirket ekle.
INSERT INTO company (company_name, industry) VALUES
('TechNova', 'technology'),
('FinCore', 'finance'),
('Sportly', 'sports');

-- 6 staj ilanı ekle: her şirket için 2 ilan.
INSERT INTO internship
(company_id, title, description, application_deadline, capacity, start_date, end_date)
VALUES
(1, 'Software Developer Intern', 'Software development and testing', '2026-12-01', 8, '2027-01-05', '2027-02-05'),
(1, 'Data Analyst Intern', 'Data analysis and reporting', '2026-12-05', 5, '2027-01-10', '2027-02-10'),
(2, 'Financial Analyst Intern', 'Financial reporting and analysis', '2026-12-08', 4, '2027-01-05', '2027-02-05'),
(2, 'Accounting Intern', 'Accounting operations support', '2026-12-10', 3, '2027-01-12', '2027-02-12'),
(3, 'Sports Data Intern', 'Analysis of sports performance data', '2026-12-12', 4, '2027-01-05', '2027-02-05'),
(3, 'Sports Marketing Intern', 'Sports marketing and campaign support', '2026-12-15', 3, '2027-01-15', '2027-02-15');

-- 10 başvuru ekle.
INSERT INTO application (student_id, internship_id, application_date, status) VALUES
(1, 1, '2026-10-01', 'submitted'),
(1, 3, '2026-10-02', 'reviewing'),
(1, 5, '2026-10-03', 'accepted'),
(1, 6, '2026-10-04', 'submitted'),
(2, 1, '2026-10-05', 'reviewing'),
(2, 2, '2026-10-06', 'submitted'),
(2, 5, '2026-10-07', 'submitted'),
(3, 3, '2026-10-08', 'accepted'),
(4, 2, '2026-10-09', 'rejected'),
(5, 4, '2026-10-10', 'submitted');
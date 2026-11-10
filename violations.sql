-- Ön koşul: schema.sql, constraints.sql ve seed.sql çalışmış olmalı.
-- Her test bağımsızdır. Beklenen SQLSTATE kodları yorumlarda yazılıdır.
-- A: NOT NULL -> 23502
INSERT INTO customer(full_name,email) VALUES (NULL,'null@example.org');
-- B: FOREIGN KEY -> 23503
INSERT INTO workshop(instructor_id,title,capacity,start_date,end_date)
VALUES (999,'Unknown teacher',10,'2026-12-01','2026-12-02');
-- C: UNIQUE -> 23505
INSERT INTO customer(full_name,email) VALUES ('Duplicate','ada@example.org');
-- D: CHECK -> 23514
INSERT INTO workshop(instructor_id,title,capacity,start_date,end_date)
VALUES (1,'Over capacity',31,'2026-12-01','2026-12-02');
-- E: CHECK -> 23514
INSERT INTO workshop(instructor_id,title,capacity,start_date,end_date)
VALUES (1,'Bad dates',10,'2026-12-03','2026-12-01');
-- F: PRIMARY KEY duplicate -> 23505
INSERT INTO registration(customer_id,workshop_id,registered_on)
VALUES (1,1,'2026-11-04');
-- G: CHECK registration date -> 23514
INSERT INTO registration(customer_id,workshop_id,registered_on)
VALUES (3,3,'2019-12-31');

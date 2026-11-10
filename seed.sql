INSERT INTO instructor (instructor_id, full_name, email) VALUES
 (1,'Deniz Kaya','deniz@example.org'),(2,'Ece Arslan','ece@example.org');
INSERT INTO customer (customer_id, full_name, email) VALUES
 (1,'Ada Yılmaz','ada@example.org'),(2,'Mert Demir','mert@example.org'),(3,'Lale Koç','lale@example.org');
INSERT INTO workshop (workshop_id,instructor_id,title,capacity,start_date,end_date) VALUES
 (1,1,'Ceramics',12,'2026-12-01','2026-12-02'),
 (2,2,'Painting',8,'2026-12-05','2026-12-06'),
 (3,1,'Sculpture',20,'2026-12-10','2026-12-11');
INSERT INTO registration(customer_id,workshop_id,registered_on) VALUES
 (1,1,'2026-11-01'),(2,1,'2026-11-02'),(1,2,'2026-11-03');

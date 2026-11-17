\set VERBOSITY verbose

-- ============================================================================
-- COME 381 - Odev 2 / Bolum B: Kisit Ihlal Testleri (violations.sql)
-- Her calistirmada ayni sonucu uretmesi icin tablolari temizleyip baslangic
-- verilerini ekliyoruz.
-- ============================================================================

TRUNCATE TABLE enrollment, workshop, student, room, instructor RESTART IDENTITY CASCADE;

-- Testler icin gecerli baslangic satirlari
INSERT INTO instructor (full_name, email, specialty, city, hourly_rate, hire_date)
VALUES ('Derin Aksoy', 'derin.aksoy@sanatmerkezi.org', 'ceramics', 'Istanbul', 750.00, '2024-09-01');

INSERT INTO room (room_name, floor_no, max_capacity)
VALUES ('Atolye A1 - Seramik', 1, 20);

INSERT INTO student (full_name, email, city, membership_level, registered_at) VALUES
('Ayse Kaya', 'ayse.kaya@ogrenci.edu.tr', 'Istanbul', 'student', '2026-01-15'),
('Mert Demir', 'mert.demir@ogrenci.edu.tr', 'Istanbul', 'standard', '2026-01-20'),
('Zeynep Celik', 'zeynep.celik@ogrenci.edu.tr', 'Ankara', 'vip', '2026-02-01');

INSERT INTO workshop (title, category, instructor_id, room_id, start_date, end_date, quota, fee)
VALUES ('Temel Seramik Tornasi', 'ceramics', 1, 1, '2026-05-01', '2026-05-15', 12, 1500.00);

INSERT INTO enrollment (student_id, workshop_id, enrolled_at, attendance_status, paid_amount, rating)
VALUES (1, 1, '2026-04-20', 'completed', 1500.00, 5);

-- ============================================================================
-- 1. NOT NULL IHLAL TESTLERI (Beklenen SQLSTATE: 23502)
-- ============================================================================

-- T01 | student.full_name NOT NULL | Beklenen: 23502
INSERT INTO student (full_name, email, city, membership_level)
VALUES (NULL, 'isimsiz@ogrenci.edu.tr', 'Ankara', 'standard');

-- T02 | workshop.title NOT NULL | Beklenen: 23502
INSERT INTO workshop (title, category, instructor_id, room_id, start_date, end_date, quota, fee)
VALUES (NULL, 'painting', 1, 1, '2026-06-01', '2026-06-10', 15, 1200.00);

-- ============================================================================
-- 2. UNIQUE IHLAL TESTLERI (Beklenen SQLSTATE: 23505)
-- ============================================================================

-- T03 | uq_instructor_email | Beklenen: 23505
INSERT INTO instructor (full_name, email, specialty, city, hourly_rate)
VALUES ('Baska Egitmen', 'derin.aksoy@sanatmerkezi.org', 'painting', 'Izmir', 600.00);

-- T04 | uq_room_name | Beklenen: 23505
INSERT INTO room (room_name, floor_no, max_capacity)
VALUES ('Atolye A1 - Seramik', 2, 15);

-- T05 | uq_student_email | Beklenen: 23505
INSERT INTO student (full_name, email, city, membership_level)
VALUES ('Ayse Kaya Kopya', 'ayse.kaya@ogrenci.edu.tr', 'Bursa', 'vip');

-- T06 | uq_enrollment_student_workshop | Beklenen: 23505
INSERT INTO enrollment (student_id, workshop_id, attendance_status, paid_amount)
VALUES (1, 1, 'registered', 1500.00);

-- ============================================================================
-- 3. CHECK IHLAL TESTLERI (Beklenen SQLSTATE: 23514)
-- ============================================================================

-- T07 | chk_instructor_hourly_rate_positive | Beklenen: 23514
INSERT INTO instructor (full_name, email, specialty, city, hourly_rate)
VALUES ('Caner Yildiz', 'caner@sanatmerkezi.org', 'music', 'Istanbul', 0.00);

-- T08 | chk_room_capacity_positive | Beklenen: 23514
INSERT INTO room (room_name, floor_no, max_capacity)
VALUES ('Bozuk Salon', 0, -5);

-- T09 | chk_student_membership | Beklenen: 23514
INSERT INTO student (full_name, email, city, membership_level)
VALUES ('Selim Arslan', 'selim.arslan@ogrenci.edu.tr', 'Istanbul', 'platinum');

-- T10 | chk_workshop_quota_positive | Beklenen: 23514
INSERT INTO workshop (title, category, instructor_id, room_id, start_date, end_date, quota, fee)
VALUES ('Kontenjansiz Atolye', 'painting', 1, 1, '2026-06-01', '2026-06-05', 0, 800.00);

-- T11 | chk_workshop_fee_nonnegative | Beklenen: 23514
INSERT INTO workshop (title, category, instructor_id, room_id, start_date, end_date, quota, fee)
VALUES ('Eksi Ucretli Atolye', 'painting', 1, 1, '2026-06-01', '2026-06-05', 10, -250.00);

-- T12 | chk_workshop_category | Beklenen: 23514
INSERT INTO workshop (title, category, instructor_id, room_id, start_date, end_date, quota, fee)
VALUES ('Gastronomi Atolyesi', 'cooking', 1, 1, '2026-06-01', '2026-06-05', 10, 900.00);

-- T13 | chk_workshop_date_order | Beklenen: 23514
INSERT INTO workshop (title, category, instructor_id, room_id, start_date, end_date, quota, fee)
VALUES ('Ters Tarihli Atolye', 'photography', 1, 1, '2026-07-20', '2026-07-10', 10, 1100.00);

-- T14 | chk_enrollment_status | Beklenen: 23514
INSERT INTO enrollment (student_id, workshop_id, attendance_status, paid_amount)
VALUES (2, 1, 'pending_approval', 1500.00);

-- T15 | chk_enrollment_paid_nonnegative | Beklenen: 23514
INSERT INTO enrollment (student_id, workshop_id, attendance_status, paid_amount)
VALUES (2, 1, 'registered', -100.00);

-- T16 | chk_enrollment_rating_range | Beklenen: 23514
INSERT INTO enrollment (student_id, workshop_id, attendance_status, paid_amount, rating)
VALUES (2, 1, 'completed', 1500.00, 6);

-- ============================================================================
-- 4. FOREIGN KEY IHLAL TESTLERI - IKI YONLU (Beklenen SQLSTATE: 23503)
-- ============================================================================

-- T17 | fk_workshop_instructor (Yon 1: olmayan egitmene atolye INSERT) | Beklenen: 23503
INSERT INTO workshop (title, category, instructor_id, room_id, start_date, end_date, quota, fee)
VALUES ('Hayalet Egitmen Atolyesi', 'music', 999, 1, '2026-08-01', '2026-08-10', 10, 1000.00);

-- T18 | fk_workshop_room (Yon 1: olmayan salona atolye INSERT) | Beklenen: 23503
INSERT INTO workshop (title, category, instructor_id, room_id, start_date, end_date, quota, fee)
VALUES ('Hayalet Salon Atolyesi', 'music', 1, 999, '2026-08-01', '2026-08-10', 10, 1000.00);

-- T19 | fk_enrollment_student (Yon 1: olmayan kursiyere kayit INSERT) | Beklenen: 23503
INSERT INTO enrollment (student_id, workshop_id, attendance_status, paid_amount)
VALUES (999, 1, 'registered', 1500.00);

-- T20 | fk_enrollment_workshop (Yon 1: olmayan atolyeye kayit INSERT) | Beklenen: 23503
INSERT INTO enrollment (student_id, workshop_id, attendance_status, paid_amount)
VALUES (1, 999, 'registered', 1500.00);

-- T21 | fk_workshop_instructor (Yon 2: ON DELETE RESTRICT olan egitmeni DELETE) | Beklenen: 23001
DELETE FROM instructor WHERE instructor_id = 1;

-- T22 | fk_enrollment_workshop (Yon 2: ON DELETE NO ACTION olan atolyeyi DELETE) | Beklenen: 23503
DELETE FROM workshop WHERE workshop_id = 1;

-- ============================================================================
-- 5. SINIR TESTLERI (BOUNDARY TESTS) VE NULL TESTI (Beklenen: OK)
-- ============================================================================

-- T23 | chk_workshop_quota_positive ve chk_workshop_date_order | Beklenen: OK (sinir: quota = 1 ve ayni gun baslayip biten atolye)
INSERT INTO workshop (title, category, instructor_id, room_id, start_date, end_date, quota, fee)
VALUES ('Birebir Tek Gunluk Fotograf Analizi', 'photography', 1, 1, '2026-09-10', '2026-09-10', 1, 0.00);

-- T24 | chk_enrollment_rating_range | Beklenen: OK (sinir: en dusuk gecerli puan rating = 1)
INSERT INTO enrollment (student_id, workshop_id, attendance_status, paid_amount, rating)
VALUES (2, 1, 'completed', 1500.00, 1);

-- T25 | chk_enrollment_rating_range | Beklenen: OK (NULL testi: CHECK olan ama NOT NULL olmayan rating sutununa NULL ekleme)
INSERT INTO enrollment (student_id, workshop_id, attendance_status, paid_amount, rating)
VALUES (3, 1, 'registered', 1500.00, NULL);

-- ============================================================================
-- COME 381 - Odev 2 / Bolum D: Ornek Veri Seti (seed.sql)
-- Her tabloya 5-15 satir ekler.
-- D4 (fark) ve D6 (bolme / division) sorgularini test etmek icin ozel durumlar icerir:
--   * Ayse Kaya (id=1) ve Mert Demir (id=2): 'ceramics' kategorisindeki TUM (3/3) atolyelere katilmistir.
--   * Zeynep Celik (id=3): "neredeyse" adaydir; 3 seramik atolyesinin 2'sine (id=1, 2) katilmis,
--     3. seramik atolyesine katilmamistir; ancak baska kategorilerden de 2 atolyesi (toplam 4 kaydi) vardir.
--   * Emre Koc (id=7) ve Selin Arslan (id=8): hicbir atolyeye kaydolmamistir (D4 sonucu).
-- ============================================================================

TRUNCATE TABLE enrollment, workshop, student, room, instructor RESTART IDENTITY CASCADE;

INSERT INTO instructor (full_name, email, specialty, city, hourly_rate, hire_date) VALUES
('Derin Aksoy', 'derin.aksoy@sanatmerkezi.org', 'ceramics', 'Istanbul', 750.00, '2023-09-01'),
('Sinan Vural', 'sinan.vural@sanatmerkezi.org', 'ceramics', 'Istanbul', 800.00, '2024-02-15'),
('Leyla Erdem', 'leyla.erdem@sanatmerkezi.org', 'painting', 'Ankara', 650.00, '2024-05-10'),
('Kerem Tekin', 'kerem.tekin@sanatmerkezi.org', 'photography', 'Izmir', 700.00, '2023-11-20'),
('Nilufer Sener', 'nilufer.sener@sanatmerkezi.org', 'music', 'Istanbul', 720.00, '2025-01-10'),
('Hakan Soylu', 'hakan.soylu@sanatmerkezi.org', 'theater', 'Ankara', 680.00, '2025-03-01');

INSERT INTO room (room_name, floor_no, max_capacity) VALUES
('Atolye A1 - Seramik', 1, 16),
('Atolye A2 - Firin ve Sir', 1, 12),
('Studyo B1 - Resim', 2, 24),
('Studyo B2 - Fotograf', 2, 20),
('Sahne C1 - Muzik ve Tiyatro', 3, 30);

INSERT INTO student (full_name, email, city, membership_level, registered_at) VALUES
('Ayse Kaya', 'ayse.kaya@ogrenci.edu.tr', 'Istanbul', 'student', '2026-01-10'),
('Mert Demir', 'mert.demir@ogrenci.edu.tr', 'Istanbul', 'standard', '2026-01-12'),
('Zeynep Celik', 'zeynep.celik@ogrenci.edu.tr', 'Ankara', 'vip', '2026-01-15'),
('Burak Ozkan', 'burak.ozkan@ogrenci.edu.tr', 'Ankara', 'standard', '2026-01-18'),
('Elif Sahin', 'elif.sahin@ogrenci.edu.tr', 'Izmir', 'student', '2026-01-22'),
('Canan Yilmaz', 'canan.yilmaz@ogrenci.edu.tr', 'Izmir', 'vip', '2026-01-25'),
('Emre Koc', 'emre.koc@ogrenci.edu.tr', 'Bursa', 'standard', '2026-02-01'),
('Selin Arslan', 'selin.arslan@ogrenci.edu.tr', 'Istanbul', 'student', '2026-02-05');

INSERT INTO workshop (title, category, instructor_id, room_id, start_date, end_date, quota, fee) VALUES
('Temel Seramik Tornasi', 'ceramics', 1, 1, '2026-03-01', '2026-03-15', 12, 1500.00),
('Ileri Seramik Sir Teknikleri', 'ceramics', 2, 2, '2026-03-20', '2026-04-05', 10, 1800.00),
('El Ile Seramik Sekillendirme', 'ceramics', 1, 1, '2026-04-10', '2026-04-25', 16, 1400.00),
('Suluboya Peyzaj Atolyesi', 'painting', 3, 3, '2026-04-01', '2026-04-15', 20, 1200.00),
('Sokak Fotografciligi Teknikleri', 'photography', 4, 4, '2026-04-05', '2026-04-20', 18, 1600.00),
('Akustik Gitar ve Ritim', 'music', 5, 5, '2026-05-01', '2026-05-20', 14, 1350.00),
('Dogaclama Tiyatro Mutbagi', 'theater', 6, 5, '2026-05-05', '2026-05-25', 22, 1100.00);

INSERT INTO enrollment (student_id, workshop_id, enrolled_at, attendance_status, paid_amount, rating) VALUES
-- Ayse Kaya (id=1): 3 seramik atolyesinin tamamina + 1 resim atolyesine katildi
(1, 1, '2026-02-20', 'completed', 1500.00, 5),
(1, 2, '2026-03-10', 'completed', 1800.00, 5),
(1, 3, '2026-04-01', 'attended', 1400.00, 4),
(1, 4, '2026-03-25', 'completed', 1200.00, 5),
-- Mert Demir (id=2): 3 seramik atolyesinin tamamina katildi
(2, 1, '2026-02-21', 'completed', 1500.00, 4),
(2, 2, '2026-03-12', 'completed', 1800.00, 5),
(2, 3, '2026-04-02', 'attended', 1400.00, NULL),
-- Zeynep Celik (id=3): "Neredeyse" aday - 3 seramikten yalnizca 2'sine (1 ve 2) katildi, ama resim (4) ve fotograf (5) ile toplam 4 atolyesi var
(3, 1, '2026-02-22', 'completed', 1500.00, 5),
(3, 2, '2026-03-14', 'completed', 1800.00, 4),
(3, 4, '2026-03-26', 'completed', 1200.00, 5),
(3, 5, '2026-03-28', 'attended', 1600.00, 5),
-- Burak Ozkan (id=4): fotograf (5) ve muzik (6)
(4, 5, '2026-03-29', 'attended', 1600.00, 4),
(4, 6, '2026-04-20', 'registered', 1350.00, NULL),
-- Elif Sahin (id=5): resim (4) ve tiyatro (7)
(5, 4, '2026-03-27', 'completed', 1200.00, 3),
(5, 7, '2026-04-25', 'registered', 1100.00, NULL),
-- Canan Yilmaz (id=6): seramik (1) ve fotograf (5)
(6, 1, '2026-02-24', 'completed', 1500.00, 5),
(6, 5, '2026-03-30', 'attended', 1600.00, 4);

-- Bolum D: Ornek Veri Seti (seed.sql)
-- Her tabloya 5-15 satir ekler.
-- D4 (fark) ve D6 (bolme / division) sorgularini dogrulamak icin kurgulanmistir:
--   * Boncuk (pet_id=1) ve Karamel (pet_id=2): 'core_vaccine' kategorisindeki TUM (3/3) asilari almistir.
--   * Pamuk (pet_id=3): "neredeyse" adaydir; 3 temel asidan 2'sini (1 ve 2) almis, 3. temel asiyi almamistir;
--     fakat parazit (4) ve dis bakimi (5) ile toplam 4 islem kaydi vardir (filtresiz COUNT sorgularini yaniltir).
--   * Mavi (pet_id=7) ve Tarcin (pet_id=8): hicbir islem/asi kaydi bulunmayan hayvanlardir (D4 sonucu).

TRUNCATE TABLE pet_treatment, pet, treatment, veterinarian, pet_owner RESTART IDENTITY CASCADE;

INSERT INTO pet_owner (full_name, phone, email, district, registered_date) VALUES
('Deniz Karaca', '05321112233', 'deniz.karaca@mail.com', 'Kadikoy', '2026-01-10'),
('Baris Aydin', '05332223344', 'baris.aydin@mail.com', 'Kadikoy', '2026-01-14'),
('Seda Yildirim', '05353334455', 'seda.yildirim@mail.com', 'Besiktas', '2026-01-18'),
('Ozan Guler', '05364445566', 'ozan.guler@mail.com', 'Besiktas', '2026-01-22'),
('Pelin Mutlu', '05375556677', 'pelin.mutlu@mail.com', 'Uskudar', '2026-02-01'),
('Kaan Bozkurt', '05386667788', 'kaan.bozkurt@mail.com', 'Uskudar', '2026-02-05'),
('Derya Polat', '05397778899', 'derya.polat@mail.com', 'Bakirkoy', '2026-02-12');

INSERT INTO veterinarian (full_name, license_no, specialization, consultation_fee, employment_status) VALUES
('Dr. Emre Yalcin', 'VET-3401', 'internal_medicine', 900.00, 'active'),
('Dr. Ilayda Korkmaz', 'VET-3402', 'vaccination', 750.00, 'active'),
('Dr. Serkan Acar', 'VET-3403', 'surgery', 1250.00, 'active'),
('Dr. Melis Tunca', 'VET-3404', 'dentistry', 950.00, 'part_time'),
('Dr. Cenk Varol', 'VET-3405', 'exotic_pets', 850.00, 'on_leave');

INSERT INTO pet (owner_id, primary_vet_id, pet_name, species, birth_year, weight_kg) VALUES
(1, 1, 'Boncuk', 'cat', 2023, 4.20),
(2, 2, 'Karamel', 'dog', 2021, 14.50),
(3, 2, 'Pamuk', 'cat', 2022, 3.80),
(4, 3, 'Cesur', 'dog', 2020, 22.00),
(5, 1, 'Zeytin', 'cat', 2024, 4.60),
(6, 3, 'Pasa', 'dog', 2019, 18.30),
(7, 5, 'Mavi', 'bird', 2025, 0.35),
(1, 5, 'Tarcin', 'rabbit', 2024, 2.10);

INSERT INTO treatment (treatment_code, treatment_name, treatment_type, min_weight_kg, max_weight_kg, standard_cost) VALUES
('VAC-RAB', 'Kuduz Asisi', 'core_vaccine', 1.00, 80.00, 650.00),
('VAC-CMB', 'Karma Koruma Asisi', 'core_vaccine', 1.00, 80.00, 750.00),
('VAC-LEU', 'ViralBagisiklik Asisi', 'core_vaccine', 1.00, 80.00, 800.00),
('PAR-INT', 'Ic ve Dis Parazit Uygulamasi', 'parasite', 0.50, 90.00, 500.00),
('DEN-CLN', 'Ultrasonik Dis Tasi Temizligi', 'dental', 2.00, 70.00, 1400.00),
('CHK-GEN', 'Genel Biyokimya Muayenesi', 'checkup', 0.20, 100.00, 900.00),
('SRG-ORT', 'Yumusak Doku Operasyonu', 'surgery', 3.00, 85.00, 4500.00);

INSERT INTO pet_treatment (pet_id, treatment_id, vet_id, visit_date, next_due_date, charged_amount, follow_up_score) VALUES
-- Boncuk (pet_id=1): 3 core_vaccine asisinin tamami + dental
(1, 1, 2, '2026-02-10', '2027-02-10', 650.00, 10),
(1, 2, 2, '2026-02-24', '2027-02-24', 750.00, 9),
(1, 3, 2, '2026-03-10', '2027-03-10', 800.00, 10),
(1, 5, 4, '2026-03-20', NULL, 1400.00, 9),
-- Karamel (pet_id=2): 3 core_vaccine asisinin tamami + parasite
(2, 1, 2, '2026-02-12', '2027-02-12', 650.00, 9),
(2, 2, 2, '2026-02-26', '2027-02-26', 750.00, 10),
(2, 3, 2, '2026-03-12', '2027-03-12', 800.00, 8),
(2, 4, 1, '2026-03-25', '2026-06-25', 500.00, NULL),
-- Pamuk (pet_id=3): "Neredeyse" aday - 3 core_vaccine'den yalnizca 2'si (1 ve 2), arti parasite (4) ve dental (5) (toplam 4 islem)
(3, 1, 2, '2026-02-15', '2027-02-15', 650.00, 9),
(3, 2, 2, '2026-03-01', '2027-03-01', 750.00, 9),
(3, 4, 1, '2026-03-15', '2026-06-15', 500.00, 10),
(3, 5, 4, '2026-03-28', NULL, 1400.00, 8),
-- Cesur (pet_id=4): core_vaccine (1), dental (5), checkup (6)
(4, 1, 2, '2026-02-18', '2027-02-18', 650.00, 9),
(4, 5, 4, '2026-03-05', NULL, 1400.00, 9),
(4, 6, 1, '2026-03-22', NULL, 900.00, 10),
-- Zeytin (pet_id=5): parasite (4), checkup (6)
(5, 4, 1, '2026-03-10', '2026-06-10', 500.00, 8),
(5, 6, 1, '2026-03-29', NULL, 900.00, NULL),
-- Pasa (pet_id=6): surgery (7)
(6, 7, 3, '2026-04-02', '2026-04-16', 4500.00, 9);

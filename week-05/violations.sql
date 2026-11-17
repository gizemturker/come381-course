\set VERBOSITY verbose

-- Bolum B: Kisit Ihlal Testleri (violations.sql)
-- Tekrarlanabilir sonuc icin tablolari sifirlayip temel test satirlarini ekliyoruz.

TRUNCATE TABLE pet_treatment, pet, treatment, veterinarian, pet_owner RESTART IDENTITY CASCADE;

INSERT INTO pet_owner (full_name, phone, email, district, registered_date)
VALUES ('Deniz Karaca', '05321112233', 'deniz.karaca@mail.com', 'Kadikoy', '2026-01-10');

INSERT INTO veterinarian (full_name, license_no, specialization, consultation_fee, employment_status)
VALUES ('Dr. Emre Yalcin', 'VET-3401', 'internal_medicine', 900.00, 'active');

INSERT INTO pet (owner_id, primary_vet_id, pet_name, species, birth_year, weight_kg) VALUES
(1, 1, 'Boncuk', 'cat', 2023, 4.20),
(1, 1, 'Karamel', 'dog', 2022, 14.50),
(1, 1, 'Limon', 'bird', 2024, 0.35);

INSERT INTO treatment (treatment_code, treatment_name, treatment_type, min_weight_kg, max_weight_kg, standard_cost) VALUES
('VAC-RAB', 'Kuduz Asisi', 'core_vaccine', 1.00, 80.00, 650.00),
('CHK-GEN', 'Genel Klinik Muayene', 'checkup', 0.10, 100.00, 500.00);

INSERT INTO pet_treatment (pet_id, treatment_id, vet_id, visit_date, next_due_date, charged_amount, follow_up_score)
VALUES (1, 1, 1, '2026-03-01', '2027-03-01', 650.00, 9);

-- 1. NOT NULL Ihlal Testleri (Beklenen: 23502)

-- T01 | pet_owner.full_name NOT NULL | Beklenen: 23502
INSERT INTO pet_owner (full_name, phone, email, district)
VALUES (NULL, '05330001122', 'eksik@mail.com', 'Besiktas');

-- T02 | pet.pet_name NOT NULL | Beklenen: 23502
INSERT INTO pet (owner_id, primary_vet_id, pet_name, species, birth_year, weight_kg)
VALUES (1, 1, NULL, 'cat', 2024, 3.10);

-- 2. UNIQUE Ihlal Testleri (Beklenen: 23505)

-- T03 | uq_pet_owner_email | Beklenen: 23505
INSERT INTO pet_owner (full_name, phone, email, district)
VALUES ('Farkli Sahip', '05449998877', 'deniz.karaca@mail.com', 'Uskudar');

-- T04 | uq_veterinarian_license | Beklenen: 23505
INSERT INTO veterinarian (full_name, license_no, specialization, consultation_fee, employment_status)
VALUES ('Dr. Baska Hekim', 'VET-3401', 'surgery', 1100.00, 'active');

-- T05 | uq_treatment_code | Beklenen: 23505
INSERT INTO treatment (treatment_code, treatment_name, treatment_type, min_weight_kg, max_weight_kg, standard_cost)
VALUES ('VAC-RAB', 'Kopya Asi Kodu', 'core_vaccine', 1.00, 50.00, 600.00);

-- T06 | uq_pet_treatment_pet_treatment | Beklenen: 23505
INSERT INTO pet_treatment (pet_id, treatment_id, vet_id, visit_date, charged_amount)
VALUES (1, 1, 1, '2026-04-01', 650.00);

-- 3. CHECK Ihlal Testleri (Beklenen: 23514)

-- T07 | chk_vet_fee_positive | Beklenen: 23514
INSERT INTO veterinarian (full_name, license_no, specialization, consultation_fee, employment_status)
VALUES ('Dr. Sifir Ucret', 'VET-3499', 'dentistry', 0.00, 'active');

-- T08 | chk_vet_status | Beklenen: 23514
INSERT INTO veterinarian (full_name, license_no, specialization, consultation_fee, employment_status)
VALUES ('Dr. Gecersiz Durum', 'VET-3500', 'dentistry', 850.00, 'retired');

-- T09 | chk_pet_species | Beklenen: 23514
INSERT INTO pet (owner_id, primary_vet_id, pet_name, species, birth_year, weight_kg)
VALUES (1, 1, 'Yesil', 'iguana', 2023, 1.80);

-- T10 | chk_pet_weight_range | Beklenen: 23514
INSERT INTO pet (owner_id, primary_vet_id, pet_name, species, birth_year, weight_kg)
VALUES (1, 1, 'Eksi Kilo', 'cat', 2023, -2.00);

-- T11 | chk_treatment_type | Beklenen: 23514
INSERT INTO treatment (treatment_code, treatment_name, treatment_type, min_weight_kg, max_weight_kg, standard_cost)
VALUES ('GRM-01', 'Tiras ve Bakim', 'grooming', 1.00, 40.00, 400.00);

-- T12 | chk_treatment_weight_order | Beklenen: 23514
INSERT INTO treatment (treatment_code, treatment_name, treatment_type, min_weight_kg, max_weight_kg, standard_cost)
VALUES ('PAR-ERR', 'Ters Kilo Aralikli Damla', 'parasite', 25.00, 5.00, 450.00);

-- T13 | chk_treatment_cost_nonnegative | Beklenen: 23514
INSERT INTO treatment (treatment_code, treatment_name, treatment_type, min_weight_kg, max_weight_kg, standard_cost)
VALUES ('PAR-NEG', 'Negatif Fiyatli Islem', 'parasite', 1.00, 20.00, -150.00);

-- T14 | chk_pet_treatment_dates | Beklenen: 23514
INSERT INTO pet_treatment (pet_id, treatment_id, vet_id, visit_date, next_due_date, charged_amount)
VALUES (2, 1, 1, '2026-05-20', '2026-05-10', 650.00);

-- T15 | chk_pet_treatment_charged_nonnegative | Beklenen: 23514
INSERT INTO pet_treatment (pet_id, treatment_id, vet_id, visit_date, charged_amount)
VALUES (2, 1, 1, '2026-05-20', -50.00);

-- T16 | chk_pet_treatment_score_range | Beklenen: 23514
INSERT INTO pet_treatment (pet_id, treatment_id, vet_id, visit_date, charged_amount, follow_up_score)
VALUES (2, 1, 1, '2026-05-20', 650.00, 15);

-- 4. FOREIGN KEY Ihlal Testleri - Iki Yonlu (Beklenen: 23503 ve 23001)

-- T17 | fk_pet_owner (Yon 1: olmayan sahibe hayvan INSERT) | Beklenen: 23503
INSERT INTO pet (owner_id, primary_vet_id, pet_name, species, birth_year, weight_kg)
VALUES (999, 1, 'Sahipsiz', 'dog', 2022, 12.00);

-- T18 | fk_pet_primary_vet (Yon 1: olmayan hekime hayvan INSERT) | Beklenen: 23503
INSERT INTO pet (owner_id, primary_vet_id, pet_name, species, birth_year, weight_kg)
VALUES (1, 999, 'Hekimsiz', 'cat', 2023, 3.50);

-- T19 | fk_pet_treatment_pet (Yon 1: olmayan hayvana tedavi INSERT) | Beklenen: 23503
INSERT INTO pet_treatment (pet_id, treatment_id, vet_id, visit_date, charged_amount)
VALUES (999, 1, 1, '2026-05-01', 650.00);

-- T20 | fk_pet_treatment_treatment (Yon 1: olmayan tedavi koduna INSERT) | Beklenen: 23503
INSERT INTO pet_treatment (pet_id, treatment_id, vet_id, visit_date, charged_amount)
VALUES (2, 999, 1, '2026-05-01', 650.00);

-- T21 | fk_pet_treatment_vet (Yon 1: olmayan hekimle tedavi INSERT) | Beklenen: 23503
INSERT INTO pet_treatment (pet_id, treatment_id, vet_id, visit_date, charged_amount)
VALUES (2, 1, 999, '2026-05-01', 650.00);

-- T22 | fk_pet_treatment_treatment (Yon 2: ON DELETE RESTRICT olan tedaviyi DELETE) | Beklenen: 23001
DELETE FROM treatment WHERE treatment_id = 1;

-- T23 | fk_pet_treatment_vet (Yon 2: ON DELETE NO ACTION olan hekimi DELETE) | Beklenen: 23503
DELETE FROM veterinarian WHERE vet_id = 1;

-- 5. Sinir Testleri (Boundary Tests) ve NULL Testi (Beklenen: OK)

-- T24 | chk_pet_weight_range | Beklenen: OK (sinir: tam ust sinir 120.00 kg)
INSERT INTO pet (owner_id, primary_vet_id, pet_name, species, birth_year, weight_kg)
VALUES (1, 1, 'Herkul', 'dog', 2021, 120.00);

-- T25 | chk_pet_treatment_dates ve chk_pet_treatment_score_range | Beklenen: OK (sinir: ayni gun kontrol tarihi ve en dusuk puan = 1)
INSERT INTO pet_treatment (pet_id, treatment_id, vet_id, visit_date, next_due_date, charged_amount, follow_up_score)
VALUES (2, 1, 1, '2026-06-01', '2026-06-01', 650.00, 1);

-- T26 | chk_pet_treatment_score_range | Beklenen: OK (NULL testi: CHECK olan ama NOT NULL olmayan follow_up_score sutununa NULL ekleme)
INSERT INTO pet_treatment (pet_id, treatment_id, vet_id, visit_date, next_due_date, charged_amount, follow_up_score)
VALUES (3, 2, 1, '2026-06-02', NULL, 500.00, NULL);

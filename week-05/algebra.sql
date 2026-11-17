-- Bolum D: Iliskisel Cebir Sorgularinin SQL Karsiliklari (algebra.sql)

-- D1 | Selection (sigma) ve Projection (pi)
-- Soru: Agirligi (weight_kg) 10 kg'dan fazla olan evcil hayvanlarin adlari, turleri ve kilolari
SELECT pet_name, species, weight_kg
FROM pet
WHERE weight_kg > 10
ORDER BY pet_id;

-- D2 | Join (bowtie)
-- Soru: Uygulanan her tibbi islemin hayvan adi, islem adi ve ziyaret tarihi (ilk 10 kayit)
SELECT p.pet_name,
       t.treatment_name,
       pt.visit_date
FROM pet_treatment pt
JOIN pet p ON p.pet_id = pt.pet_id
JOIN treatment t ON t.treatment_id = pt.treatment_id
ORDER BY pt.record_id
LIMIT 10;

-- D3 | Intersection (cap)
-- Soru: Hem 'core_vaccine' (temel asi) hem de 'dental' (dis bakimi) islemi uygulanmis evcil hayvanlarin ID ve adlari
SELECT p.pet_id, p.pet_name
FROM pet p
JOIN pet_treatment pt ON pt.pet_id = p.pet_id
JOIN treatment t ON t.treatment_id = pt.treatment_id
WHERE t.treatment_type = 'core_vaccine'
INTERSECT
SELECT p.pet_id, p.pet_name
FROM pet p
JOIN pet_treatment pt ON pt.pet_id = p.pet_id
JOIN treatment t ON t.treatment_id = pt.treatment_id
WHERE t.treatment_type = 'dental'
ORDER BY pet_id;

-- D4 (Yol 1 - EXCEPT) | Difference (-)
-- Soru: Hicbir tibbi islem veya asi kaydi bulunmayan evcil hayvanlarin ID ve adlari
SELECT p.pet_id, p.pet_name
FROM pet p
EXCEPT
SELECT p.pet_id, p.pet_name
FROM pet p
JOIN pet_treatment pt ON pt.pet_id = p.pet_id
ORDER BY pet_id;

-- D4 (Yol 2 - NOT EXISTS) | Difference (-)
-- Soru: Hicbir tibbi islem veya asi kaydi bulunmayan evcil hayvanlarin ID ve adlari
SELECT p.pet_id, p.pet_name
FROM pet p
WHERE NOT EXISTS (
    SELECT 1
    FROM pet_treatment pt
    WHERE pt.pet_id = p.pet_id
)
ORDER BY p.pet_id;

-- D5 | Rename (rho) ile Oz-Birlestirme (Self-Join)
-- Soru: Ayni ilcede (district) ikamet eden farkli hayvan sahibi ciftleri
SELECT o1.district,
       o1.full_name AS owner_1,
       o2.full_name AS owner_2
FROM pet_owner o1
JOIN pet_owner o2
  ON o1.district = o2.district
 AND o1.owner_id < o2.owner_id
ORDER BY o1.district, o1.owner_id, o2.owner_id;

-- D6 | Division (div)
-- Soru: 'core_vaccine' (temel asi) grubundaki TUM asilari tamamlanmis evcil hayvanlarin ID ve adlari
SELECT p.pet_id, p.pet_name
FROM pet p
WHERE NOT EXISTS (
    SELECT 1
    FROM treatment t
    WHERE t.treatment_type = 'core_vaccine'
      AND NOT EXISTS (
          SELECT 1
          FROM pet_treatment pt
          WHERE pt.pet_id = p.pet_id
            AND pt.treatment_id = t.treatment_id
      )
)
ORDER BY p.pet_id;
